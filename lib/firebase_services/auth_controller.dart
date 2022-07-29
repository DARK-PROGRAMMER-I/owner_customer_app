import 'package:WSHCRD/firebase_services/basic_firebase.dart';
import 'package:WSHCRD/models/customer.dart';
import 'package:WSHCRD/models/owner.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:WSHCRD/utils/session_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  static Function onPhoneAuthSuccess = () {};
  static Function? onPhoneAuthFailure;
  static String? verificationId;

  // Functions that relates with Phone Authentication
  static final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
    verificationId = verId;
    print(verificationId);
  };

  static final PhoneCodeSent smsCodeSent =
      (String verId, [int? forceCodeResend]) {
    onPhoneAuthSuccess(verId);
  };

  static final PhoneVerificationFailed verfiFailed =
      (FirebaseAuthException? exception) {
    onPhoneAuthFailure!(exception);
  };

  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<void> requestPhoneAuthentication(
      // Request Phone Authentication
      {phoneNo: String,
      onSuccess: Function,
      onVerificationCompleted: Function,
      onFailure: Function}) async {
    onPhoneAuthSuccess = onSuccess;
    onPhoneAuthFailure = onFailure;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 30),
        verificationFailed: verfiFailed,
        verificationCompleted: onVerificationCompleted);
  }

  static Future<String> signUpAsCustomer(Customer customer) async {
    try {
      // Register the customer info to firestore
      final customerCollection =
          FirebaseFirestore.instance.collection("customers");
      QuerySnapshot customers = await customerCollection
          .where("phoneNumber", isEqualTo: customer.phoneNumber)
          .get();
      if (customers.docs.isNotEmpty) {
        await customerCollection.doc(customers.docs[0].id).update({
          "uid": customer.uid,
          "displayName": customer.displayName,
          "phoneNumber": customer.phoneNumber,
        });
        return customers.docs[0].id;
      } else {
        try {
          DocumentReference documentReference = customerCollection.doc();
          customer.customerId = documentReference.id;
          documentReference.set(customer.toJson());
          return customer.customerId ??"";
        } catch (e) {
          return Future.value('');
        }
      }
    } catch (e) {
      return Future.value('');
    }
  }

  static Future<void> changeFullCustomerInfo(Customer customer) async {
    await db
        .collection("customers")
        .doc(customer.customerId)
        .update(customer.toJson());
  }

  static Future<void> changeFullOwnerInfo(Owner owner) async {
    await db.collection("owners").doc(owner.ownerId).update(owner.toJson());
  }

  static Future<void> changeCustomerInfo(Customer customer) async {
    // Change Customer Info
    String uid = SessionController.getUid();
    QuerySnapshot docSnapShot =
        await db.collection("customers").where('uid', isEqualTo: uid).get();
    if (docSnapShot == null) return;

    if (docSnapShot.docs.isNotEmpty) {
      docSnapShot.docs[0].reference.update(customer.toJson());
      SessionController.saveCustomerInfoToLocal(customer);
    }
  }

  static Future<String> signUpAsOwner(Owner owner) async {
    try {
      // Register the owner info to firestore
      final ownerCollection = FirebaseFirestore.instance.collection("owners");
      QuerySnapshot owners = await ownerCollection
          .where("phoneNumber", isEqualTo: owner.phoneNumber)
          .get();
      if (owners.docs.isNotEmpty) {
        await ownerCollection.doc(owners.docs[0].id).update({
          "uid": owner.uid,
          "displayName": owner.businessName,
          "phoneNumber": owner.phoneNumber,
        });
        return owners.docs[0].id;
      } else {
        DocumentReference ownerDocumentReference = ownerCollection.doc();
        owner.ownerId = ownerDocumentReference.id;
        await ownerDocumentReference.set(owner.toJson());
        return owner.ownerId ?? "";
      }
    } catch (e) {
      return Future.value('');
    }
  }

  static Future<void> changeOwnerInfo(owner) async {
    String uid = SessionController.getUid();
    QuerySnapshot docSnapShot =
        await db.collection("owners").where('uid', isEqualTo: uid).get();
    if (docSnapShot == null) return;

    if (docSnapShot.docs.isNotEmpty) {
      docSnapShot.docs[0].reference.update(owner.toJson());
      SessionController.saveOwnerInfoToLocal(owner);
    }
  }

  Future<List<dynamic>> isLogin(String phoneNumber) async {
    QuerySnapshot docSnapShot = await db
        .collection('owners')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    List<dynamic> result = [];

    if (docSnapShot == null || docSnapShot.docs.isEmpty) {
      QuerySnapshot docSnapShot = await db
          .collection("customers")
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      if (docSnapShot == null || docSnapShot.docs.isEmpty) {
        return result;
      } else {
        result.add(Global.CUSTOMER);
        result.add(docSnapShot.docs[0].data);
        return result;
      }
    } else {
      result.add(Global.OWNER);
      result.add(
          Owner.fromJson(docSnapShot.docs[0].data() as Map<String, dynamic>));
      return result;
    }
  }

  static Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
