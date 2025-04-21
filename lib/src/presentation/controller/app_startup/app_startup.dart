import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
import 'package:neuflo_learn/src/data/models/app_user_info.dart';
import 'package:neuflo_learn/src/data/repositories/token/token_repo_impl.dart';
import 'package:neuflo_learn/src/data/services/app_service/app_service.dart';
import 'package:neuflo_learn/src/data/services/data_access/hive_service.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';
import 'package:neuflo_learn/src/domain/repositories/token/token_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/connectivity/connectivity_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStartupController extends GetxController {
  RxString docname = RxString('');

  TokenRepo tokenRepo = TokenRepoImpl();

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

  RxBool isDone = RxBool(false);

  RxBool isSplashpAssed = RxBool(false);

  RxString accessToken = RxString('');
  RxString refreshToken = RxString('');

  final ConnectivityController connectivityController =
      Get.find<ConnectivityController>();

  @override
  void onInit() {
    super.onInit();
    log("initializing AppStartupController()");
    if (connectivityController.previousConnectivityResult.value !=
        ConnectivityResult.none) {
      handleUserSession();
    } else {
      log("No internet at launch. Waiting for reconnection...");
    }

    ever(connectivityController.previousConnectivityResult, (result) {
      if (isSplashpAssed.value == false) {
        if (result != ConnectivityResult.none &&
            userState.value is! Success &&
            isDone.isFalse) {
          log("Internet reconnected, trying to handle user session...");
          handleUserSession();
        }
      }
    });
  }

  Future handleUserSession() async {
    if (connectivityController.previousConnectivityResult.value ==
        ConnectivityResult.none) {
      log("❌ No internet. Skipping handleUserSession");
      userState.value = Failed(e: 'No internet connection');
      isDone.value = false;
      return;
    }
    try {
      log('--- handling user sessions ---');
      userState.value = Initial();
      await getAppStatus();

      final userInfoBox = await hiveService.getBox("basic_user_info");

      String? userInfo = userInfoBox.get('phno');
      String? curretntUserPhoneNumber = userInfo;

      if (curretntUserPhoneNumber != null || curretntUserPhoneNumber != "") {
        if (kDebugMode) {
          log('currentUserPhno : $curretntUserPhoneNumber');
        }
        String docName = "$curretntUserPhoneNumber@neuflo.io";
        docname.value = docName;

        appUser.value =
            await firestoreService.getCurrentUserDocument(userName: docName);

        log("appUser:${appUser.value}");
        if (appUser.value != null) {
          await firestoreService.dailyExamReportResetandStreakReset(
              userName: docName);

          if (kDebugMode) {
            log('current userInfo ===========> $appUser');
          }

          accessToken.value = (await getAccessToken()) ?? '';
          refreshToken.value = (await getRefreshToken()) ?? '';

          if (refreshToken.value != '') {
            final token1 =
                await tokenRepo.getNewTokens(refreshToken: refreshToken.value);
            token1.fold((l) {
              log("got it token expired()");
              userState.value = Failed(e: 'token Expired');
              isDone.value = false;
            }, (r) async {
              accessToken.value = r['access_token'];
              refreshToken.value = r['refresh_token'];
              await saveToken(
                  accessToken: r['access_token'],
                  refreshToken: r['refresh_token']);
              isDone.value = true;
              userState.value = Success(data: appUser.value);
            });
          } else {
            isDone.value = false;
            userState.value = Failed(e: 'no token');
          }
        } else {
          userState.value = Failed(e: 'User not exists');
        }
      } else {
        if (!kDebugMode) {
          log('currentUserPhno : $curretntUserPhoneNumber');
        }
        userState.value = Failed(e: 'User not exists');
      }
    } catch (e) {
      log("Error handleUserSession():$e");
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

  Future getToken({
    required int studentId,
    required String phoneNumber,
    required String fcmToken,
  }) async {
    final tokens = await tokenRepo.getToken(
        studentId: studentId, phoneNumber: phoneNumber, fcmToken: fcmToken);
    tokens.fold((l) {
      log("token generation Failed");
    }, (r) {
      saveToken(
          accessToken: r['access_token'], refreshToken: r['refresh_token']);
    });
  }

  Future<void> saveToken(
      {required String accessToken, required String refreshToken}) async {
    if (kDebugMode) {
      log("Token gotit:->  accessToken :$accessToken  refreshToken  :$refreshToken");
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }
}
