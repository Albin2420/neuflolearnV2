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

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen(netStatus);
  }

  // Check connection status when the app launches
  Future<void> _checkInitialConnection() async {
    log("Checking initial connection");
    List<ConnectivityResult> connectivityResult =
        await _connectivity.checkConnectivity();
    log("Initial connection status: $connectivityResult");
    if (connectivityResult.first == ConnectivityResult.none) {
      showConnectivityToast(message: "Connection Lost", isConnected: false);
    }
    previousConnectivityResult.value = connectivityResult.first;
  }

  // Listen to the changes in connection

  void netStatus(List<ConnectivityResult> connectivityResult) {
    log('previousConnectivityResult => $previousConnectivityResult');
    log('currentConnectivityResult => $connectivityResult');
    // Skip the first check when app opens
    if (!_isInitialCheckDone) {
      previousConnectivityResult.value = connectivityResult.first;
      _isInitialCheckDone = true;
      return;
    }

    if (previousConnectivityResult != ConnectivityResult.none &&
        connectivityResult.first == ConnectivityResult.none) {
      showConnectivityToast(message: "Connection Lost", isConnected: false);
    }
    if (previousConnectivityResult == ConnectivityResult.none &&
        connectivityResult.first != ConnectivityResult.none) {
      showConnectivityToast(message: "Back Online", isConnected: true);
    }

    previousConnectivityResult.value = connectivityResult.first;
  }

  // Show the toast when the connection is connected/disconnected
  void showConnectivityToast(
      {required String message, required bool isConnected}) {
    Fluttertoast.showToast(msg: message, textColor: Colors.white, fontSize: 26);
  }
}
