import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/presentation/controller/home/home_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/home/widgets/daily_streak.dart';
import 'package:neuflo_learn/src/presentation/screens/home/widgets/shimmer_loading.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<HomeController>();
    return Obx(
      () {
        List<Widget> streakWidgets = [];

        for (int i = 0; i < ctr.currentStreakValues.length; i++) {
          var e = ctr.currentStreakValues[i];
          Icon icon;

          if (e == 0) {
            icon = Icon(
              PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
              color: AppColors.kred,
            );
          } else if (e == 1) {
            icon = Icon(
              PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
              color: AppColors.kgreen,
            );
          } else {
            icon = Icon(
              PhosphorIcons.minusCircle(PhosphorIconsStyle.fill),
              color: AppColors.kinactive,
            );
          }

          streakWidgets.add(DailyStreak(
            icon: icon,
            day: ctr.weekdaysList[i], // You can adjust this based on `e`
          ));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ctr.streaksState.value.onState(
            onInitial: () {
              return ctr.currentStreakValues
                  .map((e) => ShimmerLoading(
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEBEBF4),
                          ),
                          child: Container(),
                        ),
                      ))
                  .toList();
            },
            success: (data) => streakWidgets,
            onFailed: (e) => streakWidgets,
            onLoading: () {
              return ctr.currentStreakValues
                  .map((e) => ShimmerLoading(
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEBEBF4),
                          ),
                          child: Container(),
                        ),
                      ))
                  .toList();
            },
          ),
        );
      },
    );
  }
}
