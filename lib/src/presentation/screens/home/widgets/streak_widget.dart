import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:neuflo_learn/src/presentation/controller/home/home_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/home/widgets/daily_streak.dart';
import 'package:neuflo_learn/src/presentation/screens/home/widgets/shimmer_loading.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<HomeController>();
    return Obx(() {
      List<Widget> streakWidgets = [];

      for (int i = 0; i < ctr.currentStreakValues.length; i++) {
        var e = ctr.currentStreakValues[i];
        log("streak e:$e");
        Widget icon;

        if (e == -1) {
          icon = SizedBox(
            height: 24,
            width: 24,
            child: Image.asset('assets/icons/incompletedays.png'),
          );
        } else if (e == 2) {
          icon = SizedBox(
            height: 24,
            width: 24,
            child: Image.asset('assets/icons/CheckCircle.png'),
          );
        } else if (e == 0) {
          icon = SizedBox(
            height: 24,
            width: 24,
            child: Image.asset('assets/icons/currentday.png'),
          );
        } else {
          icon = SizedBox(
            height: 24,
            width: 24,
            child: Image.asset('assets/icons/upcomingday.png'),
          );
        }

        streakWidgets.add(DailyStreak(widget: icon, day: ctr.weekdaysList[i]));
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ctr.streaksState.value.onState(
          onInitial: () {
            return ctr.currentStreakValues
                .map(
                  (e) => ShimmerLoading(
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEBEBF4),
                      ),
                      child: Container(),
                    ),
                  ),
                )
                .toList();
          },
          success: (data) => streakWidgets,
          onFailed: (e) => streakWidgets,
          onLoading: () {
            return ctr.currentStreakValues
                .map(
                  (e) => ShimmerLoading(
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEBEBF4),
                      ),
                      child: Container(),
                    ),
                  ),
                )
                .toList();
          },
        ),
      );
    });
  }
}
