import 'package:WSHCRD/common/profile_misc_info.dart';
import 'package:WSHCRD/models/customer.dart';
import 'package:WSHCRD/screens/customer/profile/customer_edit_profile.dart';
import 'package:WSHCRD/utils/session_controller.dart';
import 'package:flutter/material.dart';

class CustomerProfileView extends StatefulWidget {
  static const routeName = 'CustomerProfileView';
  @override
  _CustomerProfileViewState createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
 String? displayName;
 String? phoneNumber;

  @override
  void initState() {
    displayName = SessionController.getDisplayName();
    phoneNumber = SessionController.getPhoneNumber();
    super.initState();
  }

  navigateAndGetProfileInfo() async {
    var result = await Navigator.pushNamed(context, CustomerEditProfile.routeName);
    Customer customer = result as Customer;
    if (customer != null) {
      setState(() {
        displayName = customer.displayName!;
        phoneNumber = customer.phoneNumber!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile Hola ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: CircleAvatar(
                              radius: 19,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.yellow,
                                child: Text(
                                  displayName![0],
                                  style: const TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                displayName!,
                                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.phone,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    phoneNumber!,
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateAndGetProfileInfo();
                        },
                        child: Image.asset("assets/icons/edit.png"),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  center: Alignment.topLeft,
                  radius: 3,
                  colors: [
                    Color(0xFF00d18b),
                    Color(0xFF006569)
                  ], // whitish to gray/ repeats the gradient over the canvas
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const ProfileMiscInfo(),
          ],
        ),
      ),
    );
  }
}
