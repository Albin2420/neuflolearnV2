import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/data/models/chapter.dart';
import 'package:neuflo_learn/src/presentation/controller/custom_test/custom_test_controller.dart';

class CourseSelectionCard extends StatelessWidget {
  final Chapter chapter;
  final bool? isSelected;
  final Function(Chapter chapter) onChapterSelected;
  const CourseSelectionCard({
    super.key,
    required this.chapter,
    this.isSelected,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<CustomTestController>();
    return Obx(() {
      return GestureDetector(
        onTap: () => onChapterSelected(chapter),
        child: Container(
          padding: EdgeInsets.only(left: 16, top: 17, bottom: 17, right: 16),
          // height: 56,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: ctr.selectedChapters.contains(chapter)
                  ? Color(0xff18AC00)
                  : Color(0xff02012a33).withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  maxLines: 2,
                  chapter.chapterName ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              ctr.selectedChapters.contains(chapter) == true
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset('assets/icons/done.png'),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      );
    });
  }
}
