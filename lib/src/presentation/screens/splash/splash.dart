import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/screens/intro/intro.dart';
import 'package:neuflo_learn/src/presentation/screens/navigationscreen/navigationscreen.dart';
import 'package:neuflo_learn/src/presentation/screens/splash/widgets/splash_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(AppStartupController());
    return Obx(() {
      return ctr.userState.value.onState(
        onInitial: () => const SplashWidget(),
        success: (userInfo) {
          if (ctr.isDisabled.value == false) {
            return const SplashWidget();
          }
          if (ctr.isDone.value) {
            ctr.isSplashscreenPassed.value = true;
            return const NavigationScreen();
          } else {
            ctr.isSplashscreenPassed.value = true;
            return IntroScreen();
          }
        },
        onFailed: (_) {
          if (ctr.isDisabled.value == false) {
            return const SplashWidget();
          }
          ctr.isSplashscreenPassed.value = true;
          return const IntroScreen();
        },
        onLoading: () {
          return const SplashWidget();
        },
      );
    });
  }
}
