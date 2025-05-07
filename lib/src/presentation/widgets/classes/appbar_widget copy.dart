import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/data/models/chapter.dart';
import 'package:neuflo_learn/src/presentation/controller/chapter/chapter_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String subjectName;

  const CustomAppBar({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    ChapterController chapterController = Get.find<ChapterController>();
    chapterController.selectedSubjectName.value = subjectName;
    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 25,
            color: Colors.white,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Image.asset('assets/images/vector.png'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width - 70,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.subtitles),
                  // Image.asset(
                  //   // subject.icon,

                  //   height: 24,
                  //   width: 24,
                  //   errorBuilder: (context, error, stackTrace) {
                  //     return Image.asset('assets/images/steth.png');
                  //   },
                  // ),
                  const SizedBox(width: 10),
                  Text(
                    subjectName,
                    style: GoogleFonts.urbanist(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
