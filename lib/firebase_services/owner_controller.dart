import 'dart:async';

import 'package:WSHCRD/firebase_services/basic_firebase.dart';
import 'package:WSHCRD/models/bid.dart';
import 'package:WSHCRD/models/ledger.dart';
import 'package:WSHCRD/models/owner.dart';
import 'package:WSHCRD/models/payment.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:WSHCRD/utils/session_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../models/customer.dart';

class OwnerController {
  static CollectionReference requests =
      FirebaseFirestore.instance.collection("requests");
  static CollectionReference payments =
      FirebaseFirestore.instance.collection("payments");
  static CollectionReference customers =
      FirebaseFirestore.instance.collection("customers");
  static CollectionReference ledgers =
      FirebaseFirestore.instance.collection("ledgers");

  static Future<List<dynamic>> getCustomers() async {
    // Get all Customers
    String uid = SessionController.getUid();
    QuerySnapshot docSnapShot =
        await db.collection("customers").where("ownerId", isEqualTo: uid).get();

    List<dynamic> customers = [];
    for (int i = 0; i < docSnapShot.docs.length; i++) {
      customers.add(docSnapShot.docs[i]);
    }

    return customers;
  }

  static Stream<QuerySnapshot> getCustomersStream(String ownerId) {
    return customers.where("ownerIds", arrayContains: ownerId).snapshots();
  }

  static getAllLedgersForOwner(String ownerId) {
    return ledgers
        .where("ownerId", isEqualTo: ownerId)
        .orderBy('lastUpdateDateInEpoc', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getCustomerPayments(String ledgerId) {
    return payments
        .where("ledgerId", isEqualTo: ledgerId)
        .orderBy('dateTimeInEpoc', descending: true)
        .snapshots();
  }

  static Future<QuerySnapshot> getRequestOwnerID(String ownerId) {
    return customers.where("customerId", isEqualTo: ownerId).get();
  }

  static Future<Ledger> addCustomer(Customer customer) async {
    try {
      Owner owner = SessionController.getOwnerInfoFromLocal();
      DocumentReference documentReference = db.collection("customers").doc();
      bool customerAlreadyExists = false;
      if (customer.phoneNumber != null && customer.phoneNumber!.isNotEmpty) {
        QuerySnapshot querySnapshot = await customers
            .where('phoneNumber', isEqualTo: customer.phoneNumber)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          customer.customerId = querySnapshot.docs[0].id;
          customerAlreadyExists = true;
        } else {
          customer.customerId = documentReference.id;
        }
      } else {
        customer.customerId = documentReference.id;
      }

      if (!customerAlreadyExists) {
        await documentReference.set(customer.toJson());
      }

      /*

      This is to create a new ledger entry in firebase so that we can keep track of the users etc
       */

      DocumentReference ledgerDocumentReference = ledgers.doc();
      Ledger ledger = Ledger();
      ledger.customerId = customer.customerId??"";
      ledger.ownerId = owner.ownerId!;
      ledger.ledgerId = ledgerDocumentReference.id;
      DateTime dateTime = DateTime.now().toUtc();
      ledger.creationDateInEpoc = dateTime.millisecondsSinceEpoch;
      ledger.creationDate = DateFormat(Global.dateTimeFormat).format(dateTime);
      ledger.hasPayments = false;
      ledger.balance = 0;
      await ledgerDocumentReference.set(ledger.toJson());
      return ledger;
    } catch (e) {
      return Future.value(Ledger());
    }
  }

  static Future<Customer> getCustomer(String customerId) async {
    DocumentSnapshot doc =
        await db.collection("customers").doc(customerId).get();
    return Customer.fromJson(doc.data as Map<String, dynamic>);
  }

  static Future<String> deleteCustomer(
      String customerId, String ledgerId) async {
    await ledgers.doc(ledgerId).delete();
    return "success";
  }

  static Future<dynamic> addPayment(Payment payment) async {
    return await payments.doc().set(payment.toJson());
  }

  static Future<void> updateCustomerPhoneNumber(Customer customer) async {
    return db
        .collection("customers")
        .doc(customer.customerId)
        .update({"phoneNumber": customer.phoneNumber});
  }

  static Future<Owner> getOwnerInfo(String uid) async {
    print(uid);
    QuerySnapshot querySnapshot =
        await db.collection("owners").where("uid", isEqualTo: uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      return Owner.fromJson(querySnapshot.docs[0].data as Map<String, dynamic>);
    } else {
      return Future.value(Owner(ownerId: null));
    }
  }

  static getAllActiveNearByRequestsForRadius(
      double radius, LocationData myLocation) {
    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint center = geo.point(
        latitude: myLocation.latitude!, longitude: myLocation.longitude!);
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: requests as Query<Map<String, dynamic>>)
        .within(
            center: center,
            radius: radius,
            field: 'location',
            strictMode: true);
    return stream;
  }

  static getLastPayment(String customerId) {
    return payments
        .where('customerId', isEqualTo: customerId)
        .orderBy('dateTimeInEpoc', descending: true)
        .limit(1)
        .snapshots();
  }

  static getTotalBalance(String ownerId) {
    return ledgers.where('ownerId', isEqualTo: ownerId).snapshots();
  }

  static updateCustomerName(Customer customer) {
    return db
        .collection("customers")
        .doc(customer.customerId)
        .update({"displayName": customer.displayName});
  }

  static Future<void> submitNewBid({
    required Bid bid,
  }) async {
    assert(bid != null);
    await requests.doc(bid.request.requestId).update({
      "biddenBy": FieldValue.arrayUnion([bid.ownerId])
    });
    return requests
        .doc(bid.request.requestId)
        .collection("bids")
        .doc(bid.ownerId)
        .set(bid.toJson());
  }

  static getOwnerActiveBids(String ownerId) {
    return db
        .collectionGroup("bids")
        .where("ownerId", isEqualTo: ownerId)
        .where("status", isEqualTo: "active")
        .orderBy("biddenAt")
        .snapshots();
  }

  static getOwnerCompletedTasks(String ownerId) {
    return db
        .collectionGroup("bids")
        .where("ownerId", isEqualTo: ownerId)
        .where("status", isEqualTo: "complete")
        .orderBy("biddenAt")
        .snapshots();
  }

  static getOwnerBiddenRequests(String ownerId) {
    return requests.where("biddenBy", arrayContains: ownerId).snapshots();
  }

  static markAsComplete(Bid bid) async {
    await requests
        .doc(bid.request.requestId)
        .update({"status": "owner_marked_as_complete"});

    return requests
        .doc(bid.request.requestId)
        .collection("bids")
        .doc(bid.ownerId)
        .update({"status": "owner_marked_as_complete"});
  }
}
