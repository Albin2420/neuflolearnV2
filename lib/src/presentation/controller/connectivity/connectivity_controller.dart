import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  Rx<ConnectivityResult> previousConnectivityResult =
      Rx(ConnectivityResult.none);
  bool _isInitialCheckDone = false;

  // Observable to track internet connection status
  RxBool isnetConnected = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen(netStatus);
  }

  // Initial connection check
  Future<void> _checkInitialConnection() async {
    log("Checking initial connection");
    List<ConnectivityResult> connectivityResult =
        await _connectivity.checkConnectivity();
    log("Initial connection status: $connectivityResult");

    if (connectivityResult.first == ConnectivityResult.none) {
      isnetConnected.value = false;
      showConnectivityToast(message: "Connection Lost", isConnected: false);
    } else {
      isnetConnected.value = true;
    }

    previousConnectivityResult.value = connectivityResult.first;
  }

  // Handle connectivity changes
  void netStatus(List<ConnectivityResult> connectivityResult) {
    log('previousConnectivityResult => ${previousConnectivityResult.value}');
    log('currentConnectivityResult => $connectivityResult');

    if (!_isInitialCheckDone) {
      previousConnectivityResult.value = connectivityResult.first;
      _isInitialCheckDone = true;
      return;
    }

    if (connectivityResult.first == ConnectivityResult.none) {
      isnetConnected.value = false;
      if (previousConnectivityResult.value != ConnectivityResult.none) {
        showConnectivityToast(message: "Connection Lost", isConnected: false);
      }
    } else {
      isnetConnected.value = true;
      if (previousConnectivityResult.value == ConnectivityResult.none) {
        showConnectivityToast(message: "Back Online", isConnected: true);
      }
    }

    previousConnectivityResult.value = connectivityResult.first;
  }

  // Show toast (color not changed)
  void showConnectivityToast(
      {required String message, required bool isConnected}) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      fontSize: 26,
    );
  }
}
