import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/bindings/connectivity_binding.dart';
import 'package:neuflo_learn/src/presentation/screens/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class NeufloLearn extends StatelessWidget {
  const NeufloLearn({super.key});

  @override
  Widget build(BuildContext context) {
    Constant.init(context: context);
    return GetMaterialApp(
      // showPerformanceOverlay: true,
      title: 'NeufloLearn',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      initialBinding: ConnectivityBinding(),
      home: Splash(),
    );
  }
}
