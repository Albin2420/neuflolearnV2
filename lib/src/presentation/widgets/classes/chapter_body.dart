import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChapterBody extends StatelessWidget {
 

  const ChapterBody({super.key, });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Chapters",
              style: GoogleFonts.urbanist(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 20),
        // Expanded(
        //   child: Obx(() => ListView.builder(
        //         itemCount: chapterController..length,
        //         itemBuilder: (context, index) {
        //           return GestureDetector(
        //               onTap: () {
        //                 chapterController.onChapterSelected(index);
        //               },
        //               child: ChapterTile(index: index));
        //         },
        //       )),
        // )
      ],
    );
  }
}
