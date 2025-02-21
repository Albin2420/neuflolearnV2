import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';

class Filterchip extends StatelessWidget {
  final int selectedIndex;
  final String label;
  const Filterchip(
      {super.key, required this.selectedIndex, required this.label});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestHistoryController>();
    return Obx(() {
      return Container(
        height: 33,
        width: 88,
        decoration: BoxDecoration(
          border: Border.all(
            color: ctr.selectedFilter.value == selectedIndex
                ? Colors.transparent
                : Color(0xff010029),
          ),
          borderRadius: BorderRadius.circular(32),
          color: ctr.selectedFilter.value == selectedIndex
              ? Color(0xff010029)
              : Colors.transparent,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ctr.selectedFilter.value == selectedIndex
                  ? Colors.white
                  : Color(0xff010029),
            ),
          ),
        ),
      );
    });
  }
}
