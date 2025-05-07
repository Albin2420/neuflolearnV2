import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/presentation/controller/exam/exam_controller.dart';
import 'package:tex_text/tex_text.dart';

class OptionTile extends StatelessWidget {
  final int index;
  final bool? isSelected;
  final String title;
  final String? optionValue;
  final Function(String option) onTapFunction;
  final Color? tileColor;
  final Color? borderColor;
  final String? imageUrl; //
  const OptionTile({
    super.key,
    required this.isSelected,
    required this.index,
    required this.title,
    required this.onTapFunction,
    this.tileColor,
    this.borderColor,
    this.imageUrl,
    this.optionValue,
  });

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<ExamController>();

    return GestureDetector(
      onTap: () {
        onTapFunction(optionValue ?? '');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.4),
              height: 19,
              width: 19,
              decoration: BoxDecoration(
                border: Border.all(
                    // color: AppColors.KBlue,
                    ),
                shape: BoxShape.circle,
              ),
              child: Container(
                height: 14,
                width: 14,
                decoration: BoxDecoration(
                  color: isSelected ?? false
                      ? AppColors.KBlue
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(width: 8),
            // Expanded(
            //   child: LaTexT(
            //     laTeXCode: Text(
            //       title,
            //       style: GoogleFonts.urbanist(
            //         color: const Color(0xFF010029),
            //         fontWeight: FontWeight.w700,
            //         fontSize: 16,
            //       ),
            //     ),
            //   ),
            // )
            Expanded(
              child: TexText(
                title,
                style: GoogleFonts.urbanist(
                  color: const Color(0xFF010029),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
