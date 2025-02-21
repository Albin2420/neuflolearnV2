import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/data/models/app_user_info.dart';
import 'package:neuflo_learn/src/data/services/app_service/app_service.dart';
import 'package:neuflo_learn/src/data/services/data_access/hive_service.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';

class AppStartupController extends GetxController {
  /// handle user state
  Rx<Ds<AppUserInfo?>> userState = Rx(Initial());

  /// hive service
  HiveService hiveService = HiveService();

  /// firestore service
  FirestoreService firestoreService = FirestoreService();

  /// current app user
  Rxn<AppUserInfo?> appUser = Rxn();

  /// app service
  AppStatusService appStatusService = AppStatusService();

  RxInt studentId = RxInt(0);

  RxBool isDisabled = RxBool(false);

  RxBool isDemo = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    handleUserSession();
  }

  Future handleUserSession() async {
    log('--- handling user sessions ---');
    userState.value = Initial();
    await getAppStatus();

    final userInfoBox = await hiveService.getBox("basic_user_info");

    String? userInfo = userInfoBox.get('phno');
    String? curretntUserPhoneNumber = userInfo;

    if (curretntUserPhoneNumber != null || curretntUserPhoneNumber != "") {
      if (!kDebugMode) {
        log('currentUserPhno : $curretntUserPhoneNumber');
      }
      String docName = "$curretntUserPhoneNumber@neuflo.io";

      appUser.value =
          await firestoreService.getCurrentUserDocument(userName: docName);

      if (appUser.value != null) {
        if (!kDebugMode) {
          log('current userInfo => $appUser');
        }

        userState.value = Success(data: appUser.value);
      } else {
        userState.value = Failed(e: 'User not exists');
      }
    } else {
      if (!kDebugMode) {
        log('currentUserPhno : $curretntUserPhoneNumber');
      }
      userState.value = Failed(e: 'User not exists');
    }
  }

  bool disable = true;

  Future getAppStatus() async {
    final result = await appStatusService.getStatus();
    result.fold((failure) {
      isDisabled.value = false;
    }, (data) {
      isDisabled.value = data;
    });
  }
}
