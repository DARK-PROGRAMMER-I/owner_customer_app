import 'package:geoflutterfire/geoflutterfire.dart';

class Owner {
  String? uid;
  String? ownerId;
  String? businessName;
  String? phoneNumber;
  String? category;
  String? address;
  GeoFirePoint? location;
  int? creationDateInEpoc;
  String? creationDate;

  Owner(
      {this.uid,
       this.businessName,
        required this.ownerId,
         this.phoneNumber,
          this.category,
      this.address,
          this.creationDate,
      this.creationDateInEpoc,
      this.location});

  Owner.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    ownerId = json['ownerId'];
    businessName = json['businessName'];
    phoneNumber = json['phoneNumber'];
    category = json['category'];
    address = json['address'];
    creationDateInEpoc = json['creationDateInEpoc'];
    creationDate = json['creationDate'];
    location = (json['location'] != null
        ? Location.fromJson(json['location']).geoFirePoint: null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['ownerId'] = ownerId;
    data['businessName'] = businessName;
    data['phoneNumber'] = phoneNumber;
    data['category'] = category;
    data['creationDate'] = creationDate;
    data['creationDateInEpoc'] = creationDateInEpoc;
    data['address'] = address;
    if (location != null) {
      data['location'] = Location.toJson(location!);
    }
    return data;
  }
}

class Location {
  GeoFirePoint? geoFirePoint;

  Location({required this.geoFirePoint});

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
