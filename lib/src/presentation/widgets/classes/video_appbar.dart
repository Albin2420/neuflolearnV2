import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/data/models/chapter_model.dart';

class VideoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ChapterModel chapter;

  const VideoAppBar({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IconButton(
            //   onPressed: () {
            //     Get.back();
            //   },
            //   icon: Image.asset('assets/images/vector.png'),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chapter ${chapter.chapterNo}",
                  style: GoogleFonts.urbanist(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  chapter.chapterName,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 50,
            )
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
