// import 'dart:async';

// import 'package:get/get.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:neuflo_learn/src/data/services/connectivity_service.dart';

// class ConnectivityController extends GetxController {
//   // Observable to hold the current connectivity status
//   Rx<List<ConnectivityResult>> connectivityStatus =
//       Rx([ConnectivityResult.none]);

//   final ConnectivityService _connectivityService = ConnectivityService();
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

//   @override
//   void onInit() {
//     super.onInit();

//     // Initial connectivity check
//     _checkConnectivity();

//     // Listen for connectivity changes
//     _connectivitySubscription =
//         _connectivityService.onConnectivityChanged.listen((result) {
//       connectivityStatus.value = result;
//     });
//   }

//   @override
//   void onClose() {
//     // Cancel the stream subscription when the controller is disposed
//     _connectivitySubscription.cancel();
//     super.onClose();
//   }

//   // Method to check the initial connectivity status
//   Future<void> _checkConnectivity() async {
//     connectivityStatus.value = await _connectivityService.checkConnectivity();
//   }
// }
