import 'package:WSHCRD/common/algolia_text_field.dart';
import 'package:WSHCRD/firebase_services/owner_controller.dart';
import 'package:WSHCRD/models/owner.dart';
import 'package:WSHCRD/models/payment.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:WSHCRD/utils/session_controller.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class GetOrGivePayment extends StatefulWidget {
 late String customerId;
 late String customerName;
 late String ledgerId;
 late  String type;
 late double currentBalance;
 late Color iconColor;

  static const routeName = "GetOrGivePayment";

  setValues(Map<String, dynamic> data) {
    this.iconColor = data['iconColor'] != null ? data['iconColor'] : kDefaultColorSlab;
    this.customerId = data['customerId'];
    this.customerName = data['customerName'];
    this.type = data['type'];
    this.ledgerId = data['ledgerId'];
    this.currentBalance = data['currentBalance'];
  }

  @override
  _GetOrGivePaymentState createState() => _GetOrGivePaymentState();
}

class _GetOrGivePaymentState extends State<GetOrGivePayment> {
  DateFormat dateFormat = DateFormat("dd MMM yyyy");
  DateTime dateTime = DateTime.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  Owner owner = SessionController.getOwnerInfoFromLocal();

  addPayment() async {
    // Add Or Substract New Payment
    showLoadingScreen();
    Payment payment = Payment();
    payment.dateTime = DateFormat(Global.dateTimeFormat).format(dateTime.toUtc());
    payment.dateTimeInEpoc = dateTime.toUtc().millisecondsSinceEpoch;
    payment.ownerId = owner.ownerId;
    payment.customerId = widget.customerId;
    payment.ledgerId = widget.ledgerId;
    payment.remarks = notesController.text;
    payment.type = widget.type;
    payment.amount = double.parse(amountController.text);
    payment.balance =
        widget.type == Payment.GET ? widget.currentBalance + payment.amount! : widget.currentBalance - payment.amount!;
    await OwnerController.addPayment(payment);
    closeLoadingScreen();
    BotToast.showText(text: "Payment Added Successfully");
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateController.text = dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
        title: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              height: 40,
              width: 40,
              child: Center(
                child: Text(widget.customerName[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ),
              decoration: BoxDecoration(
                color: widget.iconColor,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                widget.customerName,
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Row(
                    children: <Widget>[
                      widget.type == Payment.GET
                          ? Image.asset("assets/icons/dollar.png", color: kCreditColor)
                          : Image.asset("assets/icons/dollar.png", color: kDebitColor),
                      VerticalDivider(
                        color: Colors.black.withOpacity(0.5),
                        thickness: 1,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          maxLength: 7,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: widget.type == Payment.GET ? kCreditColor : kDebitColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 35),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                            hintText: widget.type == Payment.GET ? ("Add payment") : ("Give credit"),
                            hintStyle: TextStyle(
                                color: widget.type == Payment.GET ? kCreditColor : kDebitColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: AlgoliaTextField(
                label: 'Date',
                onTap: () async {
                  dateTime = (await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900, 1, 1, 20, 50),
                    lastDate: DateTime.now(),
                  ))!;
                  if (dateTime == null) {
                    dateTime = DateTime.now();
                  } else {
                    TimeOfDay? timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (timeOfDay == null) {
                      timeOfDay = TimeOfDay.now();
                      dateTime = dateTime.add(Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute));
                    }
                  }

                  dateController.text = dateFormat.format(dateTime);
                },
                readOnly: true,
                textStyle: TextStyle(color: HexColor("#707070"), fontSize: 16),
                controller: dateController,
                suffixIcon: const Icon(Icons.keyboard_arrow_down, size: 30),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 42,
                    child: TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "add note (optional)",
                        prefixIcon: Icon(
                          Icons.note_add,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(border: Border.all(width: 1), borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 37,
                    width: 37,
                    child: FloatingActionButton(
                        backgroundColor: HexColor("#18d29f"),
                        onPressed: () {
                          if (amountController.text.isEmpty) {
                            BotToast.showText(text: "Please enter a amount");
                          } else {
                            addPayment();
                          }
                        },
                        child: const Icon(Icons.check, color: Colors.black)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
