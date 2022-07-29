import 'package:WSHCRD/common/locatization.dart';
import 'package:WSHCRD/screens/signup/pick_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:hexcolor/hexcolor.dart';

class ShopLocation extends StatefulWidget {
  final Function getShopLocation;

  const ShopLocation({Key? key, required this.getShopLocation})
      : super(key: key);

  @override
  _ShopLocationState createState() => _ShopLocationState();
}

class _ShopLocationState extends State<ShopLocation> {
  late var location;
  late LatLng latLng;
  String address = "";

  getShopLocation() async {
    // Get Shop location from google maps
    var result = await Navigator.pushNamed(
      context,
      PickLocation.routeName,
    );
    PickResult _pickResult = result as PickResult;
    setState(() {
      location = _pickResult.geometry!.location;
      address = _pickResult.formattedAddress!;
      latLng = LatLng(location.lat, location.lng);
      widget.getShopLocation(_pickResult);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3 * MediaQuery.of(context).size.height / 5,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "set your shop's location",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              height: 45,
              onPressed: () {
                getShopLocation();
              },
              color: HexColor("#18d29f"),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('set_current_location'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Image(
                      width: 30,
                      image: AssetImage(
                        "assets/icons/compass_green.png",
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).translate('set_shop_location'),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            latLng != null
                ? Column(
                    children: <Widget>[
                      Text(address),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 300,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          scrollGesturesEnabled: false,
                          zoomGesturesEnabled: false,
                          zoomControlsEnabled: false,
                          markers: {
                            Marker(
                                markerId: const MarkerId("random"),
                                position: latLng)
                          },
                          initialCameraPosition:
                              CameraPosition(target: latLng, zoom: 10),
                        ),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
