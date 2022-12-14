import 'dart:ui';

import 'package:WSHCRD/common/request_card.dart';
import 'package:WSHCRD/models/request.dart';
import 'package:WSHCRD/screens/customer/request/request_home.dart';
import 'package:flutter/material.dart';

class RequestPreviewView extends StatefulWidget {
  static const routeName = 'RequestPreviewView';
  late Request request;

  setRequest(Request request) {
    this.request = request;
  }

  @override
  _RequestPreviewViewState createState() => _RequestPreviewViewState();
}

class _RequestPreviewViewState extends State<RequestPreviewView> {
  @override
  void initState() {
    print(widget.request.toJson());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          width: EdgeInsetsGeometry.infinity.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  Image(
                    image: const AssetImage('assets/icons/checkmark.png'),
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'YOUR REQUEST HAS BEEN POSTED.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 8.0,
                          ),
                        ]),
                    child: RequestCard(
                      widget.request,
                      0,
                      priorityButtonFillColor: Colors.white,
                    ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.width * 1 / 2,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'You\'ll start recieveing your responses shortly.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(
                              context, RequestHomeView.routeName);
                        },
                        child: const Text(
                          'SEE REQUEST STATUS',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
              )
            ],
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xffad80cb), Color(0xff7451e9)],
            ),
          ),
        ),
      ),
    );
  }
}
