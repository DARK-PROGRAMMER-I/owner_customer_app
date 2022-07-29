import 'package:WSHCRD/common/locatization.dart';
import 'package:WSHCRD/common/profile_misc_info.dart';
import 'package:WSHCRD/firebase_services/auth_controller.dart';
import 'package:WSHCRD/firebase_services/owner_controller.dart';
import 'package:WSHCRD/models/owner.dart';
import 'package:WSHCRD/screens/owner/profile/owner_edit_profile.dart';
import 'package:WSHCRD/screens/signup/pick_location.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:WSHCRD/utils/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class OwnerProfile extends StatefulWidget {
  static const routeName = "OwnerProfile";

  @override
  _OwnerProfileState createState() => _OwnerProfileState();
}

class _OwnerProfileState extends State<OwnerProfile> {
  String? businessName;
  String? phoneNumber;
  String? category;
  Owner? owner;

  @override
  void initState() {
    // showLoadingScreen();
    businessName = SessionController.getBusinessName();
    phoneNumber = SessionController.getPhoneNumber();
    category = SessionController.getCategory();
  }

  navigateAndSaveChangedProfile() async {
    // Navigate to Edit Profile and Save Changed Info to Firestore/Local Storage
    var ownerResult = await Navigator.pushNamed(
      context,
      OwnerEditProfile.routeName,
    );
    owner = ownerResult as Owner;
    if (owner != null) {
      setState(() {
        businessName = owner?.businessName.toString();
        phoneNumber = owner?.phoneNumber.toString();
        category = owner?.category.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: FutureBuilder<Owner>(
            future: OwnerController.getOwnerInfo(SessionController.getUid()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                closeLoadingScreen();
                if (snapshot.data != null) {
                  owner = snapshot.data!;
                  return Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: CircleAvatar(
                                          radius: 19,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 17,
                                            backgroundColor: Colors.yellow,
                                            child: Text(
                                              businessName![0],
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            businessName!,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            height: 4,
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
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            category!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      navigateAndSaveChangedProfile();
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
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('my_store_location'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 60,
                                    child: Image.asset(
                                      'assets/icons/compass.png',
                                      color: const Color(0xff1d4ff2),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(owner?.address ?? "",
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () async {
                                    // Get Shop location from google maps
                                    var _pickResult = await Navigator.pushNamed(
                                      context,
                                      PickLocation.routeName,
                                    );
                                    PickResult pickResult =
                                        _pickResult as PickResult;
                                    if (pickResult != null &&
                                        pickResult.geometry != null) {
                                      owner?.location = GeoFirePoint(
                                          pickResult.geometry!.location.lat,
                                          pickResult.geometry!.location.lng);
                                      owner?.address =
                                          pickResult.formattedAddress;
                                      showLoadingScreen();
                                      await AuthController.changeOwnerInfo(
                                          owner);
                                      setState(() {});
                                      closeLoadingScreen();
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('change'),
                                    style: const TextStyle(
                                        color: Color(0xff1d4ff2),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xff1d4ff2), width: 2)),
                        ),
                        const ProfileMiscInfo(),
                      ],
                    ),
                  );
                } else {
                  return Center(
                      child: Text(AppLocalizations.of(context)
                          .translate('user_not_found')));
                }
              } else {
                return Center(
                  child: Container(
                    child: Text('Im Empty Container'),
                  ),
                );
              }
            }),
      ),
    );
  }
}
