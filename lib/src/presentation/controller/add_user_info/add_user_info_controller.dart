import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/data/models/app_user_info.dart';
import 'package:neuflo_learn/src/data/repositories/user/user_repo_impl.dart';
import 'package:neuflo_learn/src/data/services/data_access/hive_service.dart';
import 'package:neuflo_learn/src/data/services/firebase/firebase_auth.dart';
import 'package:neuflo_learn/src/data/services/firebase/firebase_auth_impl.dart';
import 'package:neuflo_learn/src/data/services/firestore/firestore_service.dart';
import 'package:neuflo_learn/src/data/services/twilio/twilio_service.dart';
import 'package:neuflo_learn/src/domain/repositories/user/user_repo.dart';

class AddUserInfoController extends GetxController {
//Twilio Services

  TwilioService twilio = TwilioService();

// firestore service
  FirestoreService firestoreService = FirestoreService();

  // hive service
  HiveService hiveService = HiveService();

// handle name textfield
  TextEditingController nameController = TextEditingController();

// handle email textfield
  TextEditingController emailController = TextEditingController();

// handle phone textfield
  TextEditingController phoneController = TextEditingController();

  /// firebase auth
  final Auth _auth = FirebaseAuthService();

  /// name error validation message
  RxnString nameError = RxnString('');

  /// phone number error validation message
  RxnString phoneError = RxnString('');

  /// resend timer canceled or not
  bool isTimerElapsed = false;

  Timer? countdownTimer;

  Duration myDuration = const Duration(minutes: 3);

  /// final otp
  RxString finalOtp = RxString('');

  UserRepo userRepo = UserRepoImpl();

  int currentOtp = 123456;

  @override
  void onInit() {
    super.onInit();
    setEmail();
  }

  /// setting login user email
  void setEmail() {
    User? currentUser = _auth.getCurrentUser();
    emailController.text = currentUser?.email ?? '';
    if (kDebugMode) {
      log('setting user email => ${emailController.text}');
    }
  }

  // Validator function for name
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    // Check if name contains only alphabets (spaces allowed)
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    // Check the length of the name
    if (value.length < 4) {
      return 'Name should be at least 3 characters long';
    }
    return null;
  }

  /// validate name and set approproate error message
  void validateName() {
    nameError.value = _validateName(nameController.text.trim());

    if (kDebugMode) {
      log('nameError : $nameError');
    }
  }

  /// validate phone number and set approproate error message
  void validatePhone() {
    phoneError.value = _validatePhoneNumber(phoneController.text.trim());

    if (kDebugMode) {
      log('nameError : $phoneError');
    }
  }

  // Phone number validator function
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    // Ensure the phone number contains only digits
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Phone number can only contain digits';
    }

    // Minimum and maximum length check (e.g., 10 to 15 digits)
    if (value.length < 10) {
      return 'Phone number should be at least 10 digits long';
    }

    return null; // No errors, valid phone number
  }

  Future generateOtp() async {
    currentOtp = twilio.createOtp();
    await twilio.twilioFlutter.sendSMS(
      toNumber: '+91${phoneController.text.trim()}',
      messageBody: '$currentOtp is your verification code for neuflo-learn',
    );
  }

  Future saveBasicDetails() async {
    /// saving user phone number
    final userInfoBox = await hiveService.getBox("basic_user_info");
    await userInfoBox.put("phno", phoneController.text.trim());

    String docUsername = "${phoneController.text.trim()}@neuflo.io";

    AppUserInfo? appUserInfo =
        await firestoreService.getCurrentUserDocument(userName: docUsername);

    if (appUserInfo != null) {
      int day = getCurrentDayIndex();
      List<int> streaklist = generateDaysList(day);
      log("newstreaklis:$streaklist");
      firestoreService.addBasicDetails(
        userName: docUsername,
        phonenum: phoneController.text.trim(),
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        id: appUserInfo.id ?? 0,
        imageUrl: _auth.getCurrentUser()?.photoURL ?? '',
        streaklist: streaklist,
        currentstreakIndex: day,
      );
    } else {
      int day = getCurrentDayIndex();
      List<int> streaklist = generateDaysList(day);
      log("newstreaklis:$streaklist");
      String? id = await firestoreService.uniqueid();

      int uid = int.parse(id ?? '0') + 1;
      log('ID  =>  $id');

      firestoreService.addBasicDetails(
          userName: docUsername,
          phonenum: phoneController.text.trim(),
          email: emailController.text.trim(),
          name: nameController.text.trim(),
          id: uid,
          imageUrl: _auth.getCurrentUser()?.photoURL ?? '',
          streaklist: streaklist,
          currentstreakIndex: day);

      await firestoreService.updateid(uid);
    }
  }

  int getCurrentDayIndex() {
    DateTime now = DateTime.now();

    // Get the weekday (1 = Monday, 7 = Sunday)
    int weekday = now.weekday;

    // Adjust so that 0 = Sunday, 1 = Monday, ..., 6 = Saturday
    int currentDayIndex = (weekday % 7);

    return currentDayIndex;
  }

  List<int> generateDaysList(int currentDayIndex) {
    List<int> days = List.filled(7, -1); // Start by filling all days with -1

    // Set the current day to 0
    days[currentDayIndex] = 0;

    for (int i = currentDayIndex + 1; i < days.length; i++) {
      days[i] = 1;
    }
    return days;
  }

  /// check if a user already exits with given phone number
  Future<AppUserInfo?> checkIsUserExists() async {
    String docUsername = "${phoneController.text.trim()}@neuflo.io";
    return await firestoreService.getCurrentUserDocument(userName: docUsername);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  static const int totalDuration = 3 * 60; // 3 minutes in seconds

  final _remainingSeconds = totalDuration.obs;
  final _isTimerActive = true.obs;

  int get remainingSeconds => _remainingSeconds.value;
  bool get isTimerActive => _isTimerActive.value;

  String get formattedTime {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    _remainingSeconds.value = totalDuration;
    _isTimerActive.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
      } else {
        _isTimerActive.value = false;
        timer.cancel();
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    _remainingSeconds.value = totalDuration;
    _isTimerActive.value = true;
    startTimer();
  }

  void resendOtp() {
    // Add OTP resend logic
    startTimer();
  }
}
