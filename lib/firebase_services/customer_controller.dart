import 'package:WSHCRD/models/bid.dart';
import 'package:WSHCRD/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location_platform_interface/location_platform_interface.dart';

class CustomerController {
  static CollectionReference requests =
      FirebaseFirestore.instance.collection("requests");

  static Future<dynamic> addRequest(Request request) async {
    DocumentReference documentReference = requests.doc();
    request.requestId = documentReference.id;
    return documentReference.set(request.toJson());
  }

  static getAllActiveRequests(String customerId, DateTime dateTime) {
    return requests
        .where('ownerId', isEqualTo: customerId)
        .endAt([dateTime.millisecondsSinceEpoch])
        .orderBy('creationDateInEpoc', descending: true)
        .snapshots();
  }

  static getAllActiveNearByRequestsForRadius(
      DateTime dateTime, double radius, LocationData myLocation) {
    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint center = geo.point(
        latitude: myLocation.latitude!, longitude: myLocation.longitude!);
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: requests as Query<Map<String, dynamic>>)
        .within(center: center, radius: radius, field: 'location');
    return stream;
  }

  static getAllExpiredRequests(String customerId, DateTime dateTime) {
    return requests
        .where('ownerId', isEqualTo: customerId)
        .startAt([dateTime.millisecondsSinceEpoch])
        .orderBy('creationDateInEpoc', descending: true)
        .snapshots();
  }

  static deleteRequest(String requestId) {
    if (requestId == "") {
      return;
    } else {
      return requests.doc(requestId).delete();
    }
  }

  static getAllBidsOn({required String request}) {
    return requests
        .doc(request)
        .collection("bids")
        .where("status", whereIn: ["bid_submitted"]).snapshots();
  }

  static acceptBid(Bid bid) async {
    await requests
        .doc(bid.request.requestId)
        .update({"status": "active"});
    return requests
        .doc(bid.request.requestId)
        .collection("bids")
        .doc(bid.ownerId)
        .update({"status": "active"});
  }

  static Stream<DocumentSnapshot> getBid(Bid bid) {
    return requests
        .doc(bid.request.requestId)
        .collection("bids")
        .doc(bid.ownerId)
        .snapshots();
  }

  static markAsComplete(Bid bid) async {
    await requests
        .doc(bid.request.requestId)
        .update({"status": "complete"});
    return requests
        .doc(bid.request.requestId)
        .collection("bids")
        .doc(bid.ownerId)
        .update({"status": "complete"});
  }
}
