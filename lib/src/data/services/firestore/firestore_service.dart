import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:neuflo_learn/src/data/models/app_user_info.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService _instance = FirestoreService._();

  factory FirestoreService() => _instance;

  Future setStreakData(
      {required String userName, required List streakvalue}) async {
    await FirebaseFirestore.instance
        .collection("neuflo_basic")
        .doc(userName)
        .update({
      'streakComplted': streakvalue,
    });
  }

  Future<AppUserInfo?> getCurrentUserDocument(
      {required String userName}) async {
    if (kDebugMode) {
      // log('USER NAME => $userName');
    }
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("neuflo_basic")
        .doc(userName)
        .get();

    if (kDebugMode) {
      log('CURRENT USER DOCUMENT => ${snap.data()}');
    }
    if (snap.data() != null) {
      Map<String, dynamic> data = jsonDecode(jsonEncode(snap.data()));

      AppUserInfo userInfo = AppUserInfo.fromMap(data);
      if (kDebugMode) {
        // log('AppUserInfo => $userInfo');
      }
      return userInfo;
    } else {
      return null;
    }
  }

  Future addBasicDetails({
    required String userName,
    required String phonenum,
    required String? email,
    required String? name,
    String? imageUrl,
    required int id,
    bool? isProfileSetupComplete,
  }) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    await FirebaseFirestore.instance
        .collection("neuflo_basic")
        .doc(userName)
        .set({
      'streakComplted': [-1, -1, -1, -1, -1, -1, -1],
      "Todate": formattedDate,
      "phone": phonenum,
      "email": email,
      "name": name,
      "imageUrl": imageUrl,
      "id": id,
      "isProfileSetupComplete": isProfileSetupComplete
    });
  }

  Future createUser({
    required String phonenum,
  }) async {
    await FirebaseFirestore.instance
        .collection("neuflo_users")
        .doc(phonenum)
        .set({
      "phone": phonenum,
    });
  }

  void updateBasicDetails({
    required String userName,
    required String? email,
    required String? name,
  }) async {
    await FirebaseFirestore.instance
        .collection("neuflo_basic")
        .doc(userName)
        .update({
      "email": email,
      "name": name,
    });
  }

  void addPhoneDetails(
      {required String userName, required String phonenum}) async {
    await FirebaseFirestore.instance
        .collection("neuflo_basic")
        .doc(userName)
        .update({
      "phone": phonenum,
    });
  }

  Future<dynamic> getStreakValueFromFirebase({
    required String userName,
  }) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("neuflo_basic")
        .doc(userName)
        .get();
    Map<String, dynamic> data = jsonDecode(jsonEncode(snap.data()));

    // streakFromFirebase = data["streakComplted"];

    if (kDebugMode) {
      // log('STREAK COMPLETED ===> $data["streakComplted"]');
    }
    return data["streakComplted"];
  }

  Future<String> getTodateFromFirebase({required String userName}) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("neuflo_basic")
        .doc(userName)
        .get();
    Map<String, dynamic> data = jsonDecode(jsonEncode(snap.data()));
    return data["Todate"];
  }

  Future<void> updateListExamId(
      {required String userName, required List examId}) async {
    await FirebaseFirestore.instance
        .collection("neuflo_basic")
        .doc(userName)
        .update({"dailyTestIds": examId});
  }

  Future<List> getListExamId({
    required String userName,
  }) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("neuflo_basic")
        .doc(userName)
        .get();
    Map<String, dynamic> data = jsonDecode(jsonEncode(snap.data()));

    // log('practiceTestId from FIRESTORE ===> $data');

    if (data['dailyTestIds'] == null) {
      return [];
    } else {
      return data['dailyTestIds'];
    }
  }

  Future<void> updateTodate(
      {required String userName, required String date}) async {
    await FirebaseFirestore.instance
        .collection("neuflo_basic")
        .doc(userName)
        .update({'Todate': date});
  }

  Future<bool> doesDocumentExist(
      {required String userName, required String collectionName}) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection(collectionName);
    final DocumentSnapshot document = await collection.doc(userName).get();
    return document.exists;
  }

  Future<AppUserInfo?> getUserDocumentByEmail({required String email}) async {
    var collectionRef = FirebaseFirestore.instance.collection('neuflo_basic');

    // Query to find the document with the matching email
    QuerySnapshot querySnapshot =
        await collectionRef.where('email', isEqualTo: email).get();

    // If we find a document, return the first document from the query
    if (querySnapshot.docs.isNotEmpty) {
      if (querySnapshot.docs.first.data() != null) {
        Map<String, dynamic> data =
            jsonDecode(jsonEncode(querySnapshot.docs.first.data()));

        AppUserInfo userInfo = AppUserInfo.fromMap(data);
        if (kDebugMode) {
          log('USER EXISITING FOR THE GOOGLE USER => $userInfo');
        }
        return userInfo;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<int> getId({
    required String userName,
  }) async {
    log('  GET ID USERNAME => $userName');
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('neuflo_basic')
        .doc(userName)
        .get();
    Map<String, dynamic> dataId = jsonDecode(jsonEncode(snap.data()));
    return dataId['id'];
  }

  Future<String?> uniqueid() async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('neuflo_counter')
        .doc('uniquid')
        .get();
    Map<String, dynamic> dataId = jsonDecode(jsonEncode(snap.data()));
    // log('dataId : ${dataId['counter']}');
    return dataId['counter'];
  }

  Future<void> updateid(int id) async {
    await FirebaseFirestore.instance
        .collection('neuflo_counter')
        .doc('uniquid')
        .set({'counter': id.toString()});
  }

  Future<void> deleteDocument({required String docName}) async {
    try {
      // Get a reference to the document
      DocumentReference documentRef =
          FirebaseFirestore.instance.collection('neuflo_basic').doc(docName);

      // Delete the document
      await documentRef.delete();

      if (kDebugMode) {
        log('Document with ID: $docName deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        log('Error deleting document from firestore : $e');
      }
    }
  }
}
