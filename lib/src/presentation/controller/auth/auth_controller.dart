import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/data/models/app_user_info.dart';
import 'package:neuflo_learn/src/data/repositories/token/token_repo_impl.dart';
import 'package:neuflo_learn/src/data/services/data_access/hive_service.dart';
import 'package:neuflo_learn/src/data/services/firebase/firebase_auth.dart';
import 'package:neuflo_learn/src/data/services/firebase/firebase_auth_impl.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';
import 'package:neuflo_learn/src/data/services/twilio/twilio_service.dart';
import 'package:neuflo_learn/src/domain/repositories/token/token_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';

class AuthController extends GetxController {
  TextEditingController textCtr = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  TokenRepo trp = TokenRepoImpl();

  final ctrl = Get.find<AppStartupController>();

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

  final appctr = Get.find<AppStartupController>();

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

      currentFirestoreAppUser.value =
          await firestoreService.getUserDocumentByEmail(
        email: currentAppUser.value?.email ?? '',
      );

      Get.find<AppStartupController>().appUser.value =
          currentFirestoreAppUser.value;

      final userInfoBox = await hiveService.getBox("basic_user_info");
      await userInfoBox.put("phno", currentFirestoreAppUser.value?.phone ?? '');

      log("currentFirestoreUser => $currentFirestoreAppUser");

      final String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

      if (fcmToken != '' &&
          currentFirestoreAppUser.value?.phone != null &&
          currentFirestoreAppUser.value?.id != null) {
        appctr.getToken(
            fcmToken: fcmToken,
            studentId: currentFirestoreAppUser.value?.id ?? 0,
            phoneNumber: currentFirestoreAppUser.value?.phone ?? '');
      }
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

  Future<bool> getNewToken(
      {required int studentId, required String phoneNumber}) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (studentId == 0 ||
          phoneNumber.isEmpty ||
          (fcmToken?.isEmpty ?? true)) {
        log("Invalid input: studentId should not be 0, phoneNumber should not be empty, and FCM token should not be empty.");
        return false;
      }

      final tokens = await trp.getToken(
        studentId: studentId,
        phoneNumber: phoneNumber,
        fcmToken: fcmToken ?? '',
      );

      return tokens.fold(
        (l) {
          log("Error in getNewToken(): $l");
          return false;
        },
        (R) {
          log("Access Token: ${R["access_token"]}");
          log("Refresh Token: ${R["refresh_token"]}");
          ctrl.saveToken(
            accessToken: R["access_token"],
            refreshToken: R["refresh_token"],
          );
          return true;
        },
      );
    } catch (e) {
      log("Exception in getNewToken(): $e");
      return false;
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
