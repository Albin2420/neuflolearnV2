import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/data/models/app_user_info.dart';
import 'package:neuflo_learn/src/data/services/data_access/hive_service.dart';
import 'package:neuflo_learn/src/data/services/firebase/firebase_auth.dart';
import 'package:neuflo_learn/src/data/services/firebase/firebase_auth_impl.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';
import 'package:neuflo_learn/src/data/services/twilio/twilio_service.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';

class AuthController extends GetxController {
  TextEditingController textCtr = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  /// firebase auth
  final Auth _auth = FirebaseAuthService();

  /// hive service
  HiveService hiveService = HiveService();

  /// twilio
  TwilioService twilioService = TwilioService();

  /// auth status
  Rx<AuthStatus> authStatus = Rx(AuthStatus.undefined);

  PageController controller = PageController();

  RxInt currentOtp = RxInt(0);

  Rxn<User> currentAppUser = Rxn(null);

  Rxn<AppUserInfo> currentFirestoreAppUser = Rxn(null);

  /// sign in with googel
  Future singInWithGoogle() async {
    if (_auth.getCurrentUser() == null) {
      await _auth.signOut();
    }

    if (_auth.getCurrentUser() != null) {
      await _auth.signOut();
    }

    AuthStatus? authStatus = await _auth.signInWithGoogle();

    log('authStatus : $authStatus');

    if (authStatus == AuthStatus.successful) {
      currentAppUser.value = _auth.getCurrentUser();
      var token = await currentAppUser.value?.getIdToken();
      log("token in google():$token");
      currentFirestoreAppUser.value =
          await firestoreService.getUserDocumentByEmail(
        email: currentAppUser.value?.email ?? '',
      );

      Get.find<AppStartupController>().appUser.value =
          currentFirestoreAppUser.value;

      final userInfoBox = await hiveService.getBox("basic_user_info");
      await userInfoBox.put("phno", currentFirestoreAppUser.value?.phone ?? '');

      log("currentFirestoreUser => $currentFirestoreAppUser");
      setAuthStatus(status: AuthStatus.successful);
    } else {
      await _auth.signOut();
      setAuthStatus(status: AuthStatus.failed);
    }

    log(_auth.getCurrentUser().toString());
  }

  Future signOut() async {
    await _auth.signOut();

    await restSessionValues();
  }

  Future restSessionValues() async {
    final userInfoBox = await hiveService.getBox("basic_user_info");

    await userInfoBox.put('phno', '');
    String? userInfo = userInfoBox.get('phno');
    log("USER PHONE NUMBER => $userInfo");
  }

  void setAuthStatus({required AuthStatus status}) {
    if (kDebugMode) {
      log('setting auth status : $authStatus');
    }
    authStatus.value = status;
  }

  RxBool isAccountDeleteComplete = RxBool(false);

  Future deleteUserAccount() async {
    try {
      final userInfoBox = await hiveService.getBox("basic_user_info");

      String? userInfo = userInfoBox.get('phno');
      String? curretntUserPhoneNumber = userInfo;

      if (curretntUserPhoneNumber != null || curretntUserPhoneNumber != "") {
        if (!kDebugMode) {
          log('currentUserPhno : $curretntUserPhoneNumber');
        }
        String docName = "$curretntUserPhoneNumber@neuflo.io";
        await firestoreService.deleteDocument(docName: docName);
        User? currentUser = _auth.getCurrentUser();
        await currentUser?.delete();
      }
      isAccountDeleteComplete.value = true;
    } on Exception {
      isAccountDeleteComplete.value = false;
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
