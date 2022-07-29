import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Request extends ChangeNotifier {
  static const PARAGRAPH = "Paragraph";
  static const LIST = "List";
  static const REQ_VISIBILITY_STORES_ONLY = 0;
  static const REQ_VISIBILITY_NEARBY_ONLY = 1;
  static const REQ_VISIBILITY_BOTH = 2;
  String? requestId;
  String? address;
  int? priority;
  String? category;
  String? type;
  List<String>? itemArray;
  List<String>? biddenBy;
  String? itemParagraph;
  String? status;
  GeoFirePoint? location;
  bool? paymentRequired;
  int? requestVisibility;
  int? creationDateInEpoc;
  String? creationDate;
  String? ownerId;

  setPriority(priority) {
    this.priority = priority;
    notifyListeners();
  }

  setRequestVisibility(requestVisibility) {
    this.requestVisibility = requestVisibility;
    notifyListeners();
  }

  Request(
      {this.address,
      this.requestId,
      this.priority,
      this.category,
      this.type,
      this.itemArray,
      this.itemParagraph,
      this.paymentRequired,
      this.requestVisibility,
      this.creationDateInEpoc,
      this.creationDate,
      this.location,
      this.ownerId});

  Request.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    address = json['address'];
    priority = json['priority'];
    category = json['category'];
    type = json['type'];
    itemArray = json['itemArray']?.cast<String>();
    biddenBy = json['biddenBy']?.cast<String>();
    itemParagraph = json['itemParagraph'];
    paymentRequired = json['paymentRequired'];
    requestVisibility = json['requestVisibility'];
    creationDateInEpoc = json['creationDateInEpoc'];
    creationDate = json['creationDate'];
    ownerId = json['ownerId'];
    status = json["status"];
    if (json["location"] != null) {
      GeoPoint geoPoint = json['location']['geopoint'];
      location = GeoFirePoint(geoPoint.latitude, geoPoint.longitude);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['requestId'] = requestId;
    data['priority'] = priority;
    data['category'] = category;
    data['type'] = type;
    data['itemArray'] = itemArray;
    data['itemParagraph'] = itemParagraph;
    data['paymentRequired'] = paymentRequired;
    data['requestVisibility'] = requestVisibility;
    data['creationDateInEpoc'] = creationDateInEpoc;
    data['creationDate'] = creationDate;
    data['ownerId'] = ownerId;
    if (location != null) {
      data['location'] = location!.data;
    }
    return data;
  }

  Map<String, dynamic> toBasicJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['priority'] = priority;
    data['category'] = category;
    data['type'] = type;
    data['itemArray'] = itemArray;
    data['itemParagraph'] = itemParagraph;
    data['requestVisibility'] = requestVisibility;
    data['creationDateInEpoc'] = creationDateInEpoc;
    data['creationDate'] = creationDate;
    data['ownerId'] = ownerId;
    return data;
  }
}

class Location {
  GeoFirePoint? geoFirePoint;

  Location({this.geoFirePoint});

  Location.fromJson(Map<String, dynamic> json) {
    geoFirePoint = GeoFirePoint(json['latitude'], json['longitude']);
  }

  static Map<String, dynamic> toJson(GeoFirePoint geoFirePoint) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = geoFirePoint.latitude;
    data['longitude'] = geoFirePoint.longitude;
    return data;
  }
}
