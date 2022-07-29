import 'package:WSHCRD/common/algolia_text_field.dart';
import 'package:WSHCRD/firebase_services/owner_controller.dart';
import 'package:WSHCRD/models/customer.dart';
import 'package:WSHCRD/models/payment.dart';
import 'package:WSHCRD/screens/owner/credit_book/get_or_give_payment.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentView extends StatefulWidget {
  // This is the widget for Payment View
  String? customerId;
  String? customerName;
  Color? iconColor;
  String? ledgerId;

  static const routeName = "PaymentView";

  setValues(Map<String, dynamic> values) {
    customerId = values['customerId'];
    customerName = values['customerName'];
    iconColor = values['iconColor'] != null ? Color(values['iconColor']) : kDefaultColorSlab;
    ledgerId = values['ledgerId'];
    if (kDebugMode) {
      print('ledger id $ledgerId');
    }
  }

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  List<Payment> paymentList = [];
 late Customer customer;
  DateFormat timeFormat = DateFormat("hh:mm aa");
  DateFormat dateFormat = DateFormat("MMM dd, yyyy");
 late DateTime time;
  late String currentDate;
  final ScrollController _scrollController = ScrollController();
  late Future contactsFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              height: 40,
              width: 40,
              child: Center(
                child: Text(widget.customerName![0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ),
              decoration: BoxDecoration(
                color: widget.iconColor,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                widget.customerName??"",
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (customer.phoneNumber != null && customer.phoneNumber!.isNotEmpty) {
                    launch('tel:${customer.phoneNumber}');
                  } else {
                    Global.showToastMessage(context: context, msg: 'Please add mobile number');
                  }
                },
                child: const Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
              ),
              PopupMenuButton(
                onSelected: (selected) async {
                  switch (selected) {
                    case 1:
                      showEditCustomerScreen();
                      break;
                    case 2:
                      deleteCustomerAndReturnToPreviousScreen();
                      break;
                  }
                },
                itemBuilder: (context) {
                  var list = <PopupMenuEntry>[];
                  list.add(
                    const PopupMenuItem(
                      child: Text("Edit", style: TextStyle(fontWeight: FontWeight.w600)),
                      value: 1,
                    ),
                  );

                  list.add(
                    const PopupMenuItem(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: 2,
                    ),
                  );
                  return list;
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FutureBuilder<Customer>(
                future: OwnerController.getCustomer(widget.customerId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    customer = snapshot.data ?? Customer();
                    if (snapshot.data!.phoneNumber == null) {
                      return Container(
                        height: 85,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50,
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                  "Add ${widget.customerName}'s contact number to easily contact and remind them for dues"),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(width: 1, color: Colors.black)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: MaterialButton(
                                  onPressed: () {
                                    getMobileNumber(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const <Widget>[
                                      Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Add mobile number",
                                        style:
                                            TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: kCreditColor,
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }
                  }

                  return Container();
                }),
            StreamBuilder<QuerySnapshot>(
                stream: OwnerController.getCustomerPayments(widget.ledgerId ?? ""),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    paymentList = snapshot.data!.docs.map((e) => Payment.fromJson(e.data as Map<String,dynamic>)).toList();
                    paymentList ??= [];

                    // iterate over the payments to show the balance and and all the other info

                    if (paymentList.length > 1) {
                      paymentList[paymentList.length - 1].balance =
                          paymentList[paymentList.length - 1].type == Payment.GET
                              ? paymentList[paymentList.length - 1].amount
                              : -paymentList[paymentList.length - 1].amount!;
                      for (int i = paymentList.length - 2; i >= 0; i--) {
                        paymentList[i].balance = paymentList[i].type == Payment.GET
                            ? paymentList[i + 1].balance! + paymentList[i].amount!
                            : paymentList[i + 1].balance! - paymentList[i].amount!;
                      }
                    }
                    currentDate = '';
                    List<Widget> columns = [];
                    columns.add(
                      Expanded(
                        child: ListView.builder(
                            controller: _scrollController, itemCount: paymentList.length, itemBuilder: payment),
                      ),
                    );
                    columns.addAll(getReminderView());
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: columns,
                      ),
                    );
                  }
                  return Expanded(
                      child: Container(
                    child: Center(child: Text('No Transactions found for ${widget.customerName}')),
                  ));
                }),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: kBorderColor, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: MaterialButton(
                                height: 65,
                                onPressed: () {
                                  goToGiveOrGetPayment(Payment.GET);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_downward,
                                      color: kCreditColor,
                                    ),
                                    Text(
                                      "Payment",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: kCreditColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            width: 1,
                            color: kBorderColor,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: const EdgeInsets.only(left: 3),
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  height: 65,
                                  onPressed: () {
                                    goToGiveOrGetPayment(Payment.GIVE);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Credit",
                                        style: TextStyle(
                                            fontSize: 15, color: HexColor("#e9194b"), fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      ),
                                      Icon(
                                        Icons.arrow_upward,
                                        color: HexColor("#e9194b"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  /*
  calculate time differnece so that it can be shown as Today,10 June 2020 etc
   */
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  Widget payment(BuildContext context, int index) {
    String balanceText =
        '${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(paymentList[index].balance?.abs())} ' +
            (paymentList[index].balance! > 0 ? "Advance" : "Due");
    DateTime dateTime = (DateTime.fromMillisecondsSinceEpoch(paymentList[index].dateTimeInEpoc!, isUtc: true).toLocal());
    String date = calculateDifference(dateTime) == 0 ? 'Today' : dateFormat.format(dateTime);
    List<Widget> widgets = [];
    if (date != currentDate) {
      currentDate = date;
      widgets.add(
        const SizedBox(
          height: 10,
        ),
      );
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Center(
                child: Text(
                  currentDate,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ],
        ),
      );
      widgets.add(
        const SizedBox(
          height: 10,
        ),
      );
    }
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment:
                  paymentList[index].type == Payment.GET ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(paymentList[index].amount),
                            style: TextStyle(
                              color: paymentList[index].type == Payment.GET ? kCreditColor : kDebitColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            timeFormat.format(
                                DateTime.fromMillisecondsSinceEpoch(paymentList[index].dateTimeInEpoc!, isUtc: true)
                                    .toLocal()),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      paymentList[index].remarks != null && paymentList[index].remarks!.isNotEmpty
                          ? ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width / 2,
                              ),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    paymentList[index].remarks ??"",
                                    style: const TextStyle(color: Colors.black, fontSize: 12),
                                    overflow: TextOverflow.clip,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: kBorderColorLight), borderRadius: BorderRadius.circular(5)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  paymentList[index].type == Payment.GET ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 8 / 15,
                    padding: const EdgeInsets.only(top: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                      alignment: paymentList[index].type == Payment.GET ? Alignment.centerLeft : Alignment.centerRight,
                      child: Text(
                        balanceText,
                        style: TextStyle(fontSize: 12, color: HexColor("#707070"), fontWeight: FontWeight.w600),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
    return Column(
      children: widgets,
    );
  }

  List<Widget> getReminderView() {
    return [
      const SizedBox(
        height: 10,
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            paymentList.length != 0 && paymentList[paymentList.length - 1].balance != null
                ? Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    child: paymentList[0].balance! < 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                "Balance Due",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                NumberFormat.currency(symbol: '\$').format(paymentList[0].balance?.abs()),
                                style: TextStyle(color: kDebitColor, fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                "Balance Advance",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                NumberFormat.currency(symbol: '\$').format(paymentList[0].balance?.abs()),
                                style: TextStyle(color: kCreditColor, fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                    decoration: const BoxDecoration(
                      color: Color(0xffEDF1F2),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          "Balance Due",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          NumberFormat.currency(symbol: '\$').format(0),
                          style: TextStyle(color: kDebitColor, fontSize: 17, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEDF1F2),
                      border: Border(bottom: BorderSide(width: 1, color: kBorderColorLight)),
                    ),
                  ),
            Visibility(
              visible: paymentList.isNotEmpty && paymentList[0].balance != null && paymentList[0].balance! < 0,
              child: Container(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 1 / 5),
                  child: MaterialButton(
                    onPressed: () {
                      if (customer.phoneNumber != null && customer.phoneNumber!.isNotEmpty) {
                        launch('tel:${customer.phoneNumber}');
                      } else {
                        Global.showToastMessage(context: context, msg: 'Please add mobile number');
                      }
                    },
                    color: kCreditColor,
                    height: 35,
                    child: const Text(
                      "Request Payment",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(width: 1, color: kBorderColorLight)),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: kBorderColorLight),
          borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
              ),
        ),
      ),
    ];
  }

  void getMobileNumber(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Mobile Number"),
            content: InternationalPhoneNumberInput(onInputChanged: (PhoneNumber value) {
              customer.phoneNumber = "${value.dialCode} ${value.phoneNumber}";
            },
              hintText: 'Enter your number',
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text("OK"),
                onPressed: () async {
                  if (customer.phoneNumber == null || customer.phoneNumber!.isEmpty) {
                    Global.showToastMessage(context: context, msg: "Invalid Number");
                  } else {
                    showLoadingScreen();
                    try {
                      await OwnerController.updateCustomerPhoneNumber(customer);
                      Global.showToastMessage(context: context, msg: "Update Successful");
                    } catch (e) {
                      Global.showToastMessage(context: context, msg: "Update failed");
                    }

                    setState(() {});
                    closeLoadingScreen();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }
  /*
  populate the fields and go to payment screen
   */

  void goToGiveOrGetPayment(String type) {
    Navigator.pushNamed(context, GetOrGivePayment.routeName, arguments: {
      'color': widget.iconColor!.value,
      'customerId': widget.customerId,
      'customerName': widget.customerName,
      'ledgerId': widget.ledgerId,
      'iconColor': widget.iconColor,
      'currentBalance': (paymentList == null || paymentList.isEmpty) ? 0.0 : paymentList[0].balance,
      'type': type,
    });
  }

  void showEditCustomerScreen() {
    TextEditingController nameController = TextEditingController();
    nameController.text = widget.customerName!;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Edit Customer"),
            actions: <Widget>[
              FlatButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text("Save"),
                onPressed: () async {
                  updateCustomer(nameController);
                },
              ),
            ],
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AlgoliaTextField(
                    label: 'Name',
                    controller: nameController,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> deleteCustomerAndReturnToPreviousScreen() async {
    showLoadingScreen();
    try {
      await OwnerController.deleteCustomer(customer.customerId!, widget.ledgerId!);
    } catch (e) {
      BotToast.showText(text: 'Error deleting customer');
    }
    closeLoadingScreen();
    Navigator.pop(context);
  }

  Future<void> updateCustomer(TextEditingController nameController) async {
    if (nameController.text.isEmpty) {
      Global.showToastMessage(context: context, msg: "Name cannot be empty!!");
    } else {
      if (widget.customerName == nameController.text) {
        Global.showToastMessage(context: context, msg: "There is no difference in the name");
      } else {
        showLoadingScreen();
        try {
          customer.displayName = nameController.text;
          await OwnerController.updateCustomerName(customer);
          widget.customerName = nameController.text;
          Global.showToastMessage(context: context, msg: "Update Successful");
        } catch (e) {
          Global.showToastMessage(context: context, msg: "Update failed");
        }
        setState(() {});
        closeLoadingScreen();
        Navigator.pop(context);
      }
    }
  }
}
