import 'package:WSHCRD/common/category_label.dart';
import 'package:WSHCRD/common/priority.dart';
import 'package:WSHCRD/models/request.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:timeago/timeago.dart' as timeago;

class RequestCard extends StatelessWidget {
  final Request request;
  final bool showPriority;
  final bool showCategory;
  final LocationData? currentLocation;
  final Color? color;
  final Function? onPressedSeeBid;
  final Function? onPressedCall;
  final Function? onPressedBid;

  const RequestCard({
    Key? key,
    required this.request,
    this.showPriority = false,
    this.showCategory = false,
    this.onPressedSeeBid,
    this.color,
    this.onPressedCall,
    this.onPressedBid,
    this.currentLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: color ?? randomColor(),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, bottom: 32, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentLocation != null
                    ? getDistanceIndicator(request, currentLocation!)
                    : const SizedBox(),
                buildTimeAgo(),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'I need the following things:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            buildRequest(),
            if (showCategory || showPriority) buildExtraInfo(),
            if (onPressedSeeBid != null) buildSeeBidButton(context),
            if (onPressedCall != null && onPressedBid != null) buildActions(),
          ],
        ),
      ),
    );
  }

  Widget buildTimeAgo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.access_time,
          size: 16,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          getTimeAgo(),
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget buildRequest() {
    List<Widget> items = [];
    if (request.type == Request.LIST) {
      int count = 1;
      for (String item in request.itemArray!) {
        items.add(
          Text(
            '${count++}. $item',
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }
    } else {
      items.add(
        Text(
          request.itemParagraph??"",
          overflow: TextOverflow.clip,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  Widget buildExtraInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PriorityWidget(
            request.priority!,
            readOnly: true,
            request: request,
          ),
          CategoryLabel(request.category!),
        ],
      ),
    );
  }

  buildSeeBidButton(BuildContext context) {
    return GestureDetector(
      onTap:()=> onPressedSeeBid,
      child: Container(
        height: 32,
        margin: const EdgeInsets.only(top: 32),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 32),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.black,
              width: 3,
            )),
        child: const Text(
          "SEE BID",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  getDistanceIndicator(Request request, LocationData currentLocation) {
    double distance = GeoFirePoint.kmDistanceBetween(
            to: request.location!.coords,
            from: Coordinates(
                currentLocation.latitude!, currentLocation.longitude!)) *
        1000;
    String distanceText;
    if (distance > 1000) {
      int newDistance = distance ~/ 1000;
      distanceText =
          '$newDistance ' + (newDistance > 1 ? 'kms away' : 'km away');
    } else {
      distanceText = '${distance.toInt()} ' +
          (distance > 1 ? 'meters away' : 'meter away');
    }
    return Row(
      children: <Widget>[
        const Icon(Icons.location_on),
        const SizedBox(
          width: 10,
        ),
        Text(
          distanceText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildActions() {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xff66FD96),
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "CALL",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    height: 15,
                    width: 15,
                    child: Image.asset(
                      'assets/icons/arrow_right.png',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: ()=>onPressedBid,
              child: Container(
                color: const Color(0xff66FD96),
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Bid",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 15,
                      width: 15,
                      child: Image.asset(
                        'assets/icons/arrow_right.png',
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getTimeAgo() {
    DateTime now = DateTime.now().toUtc();
    var creationDate = now.subtract(Duration(
        milliseconds: now
            .difference(DateTime.fromMillisecondsSinceEpoch(
                request.creationDateInEpoc ?? 0,
                isUtc: true))
            .inMilliseconds));
    return timeago.format(creationDate);
  }
}
