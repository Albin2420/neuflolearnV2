import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/screens/splash/splash.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/subject_card.dart';

class NeufloLearn extends StatelessWidget {
  const NeufloLearn({super.key});

  @override
  Widget build(BuildContext context) {
    Constant.init(context: context);
    return GetMaterialApp(
      // showPerformanceOverlay: true,
      title: 'Neuflo',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Splash(),
    );
  }
}
