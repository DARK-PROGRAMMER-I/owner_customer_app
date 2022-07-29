import 'package:WSHCRD/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bid {
  late double amount;
  late String type;
  late String ownerId;
  late String storeName;
  late GeoPoint storeLocation;
  late String status;
  late DateTime biddenAt;
  late Request request;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["amount"] = amount;
    data["type"] = type;
    data["ownerId"] = ownerId;
    data["storeName"] = storeName;
    data["storeLocation"] = storeLocation;
    data["status"] = status;
    data["biddenAt"] = biddenAt;
    data["request"] = request.toJson();
    return data;
  }

  Bid();

  Bid.fromJson(Map<String, dynamic> json) {
    amount = json["amount"] is int
        ? (json["amount"] as int).toDouble()
        : json["amount"];
    type = json["type"];
    ownerId = json["ownerId"];
    status = json["status"];
    storeName = json["storeName"];
    storeLocation = json["storeLocation"];
    biddenAt = (json["biddenAt"] as Timestamp).toDate();
    request = Request.fromJson(json["request"]);
  }
}
