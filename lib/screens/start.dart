import 'dart:async';
import 'package:WSHCRD/common/locatization.dart';
import 'package:WSHCRD/screens/signup/signup_screen.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Start extends StatefulWidget {
  static const routeName = "/";

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  String? internationalizedPhoneNumber;
  String phoneNumber = "";
  String isoCode = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendOTP() async {
    // Send OTP Code to your phone
    if (internationalizedPhoneNumber!.isEmpty) {
      Global.showToastMessage(
        context: context,
        msg: AppLocalizations.of(context).translate("invalid_phone_number"),
      );
      return;
    } else {
      Navigator.pushNamed(
        context,
        SignUpScreen.routeName,
        arguments: {
          'phoneNo': phoneNumber,
          'interPhoneNo': internationalizedPhoneNumber,
          'isoCode': isoCode
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Enter your Phone",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "number to",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "continue.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black, width: 2),
                  left: BorderSide(color: Colors.black, width: 2),
                  right: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 8,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0xffFFF34E), width: 4),
                              ),
                            ),
                            child: InternationalPhoneNumberInput(
                              inputDecoration: InputDecoration.collapsed(
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3,
                                ),
                                hintText: "55555 55555",
                              ),
                              initialValue:
                                  PhoneNumber(phoneNumber: phoneNumber),
                              onInputChanged: (PhoneNumber value) {
                                phoneNumber = value.phoneNumber!;

                                internationalizedPhoneNumber =
                                    value.phoneNumber;
                                isoCode = value.isoCode!;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: sendOTP,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffFFF34E),
                      ),
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: const Text(
                        "Lets' go",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
