import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';

class PlayAppbar extends StatelessWidget implements PreferredSizeWidget {
  int chapterNo;
  String chapterName;
  String subjectName;
  PlayAppbar({
    super.key,
    required this.chapterNo,
    required this.chapterName,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    VideosController videosController = Get.find<VideosController>();

    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          color: Colors.white,
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close),
          ),
        ),
        Container(
          color: Colors.white,
          // width: MediaQuery.of(context).size.width - 150,
          child: Column(
            children: [
              Expanded(
                child: Text(
                  chapterName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "$subjectName - Chapter $chapterNo",
                style: GoogleFonts.urbanist(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}









// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/core/config/theme/colors.dart';
// import 'package:neuflo_learn/src/presentation/controller/chapter/chapter_controller.dart';
// import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';
// import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';


// class PlayAppbar extends StatelessWidget implements PreferredSizeWidget {
//   const PlayAppbar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     VideosController videosController = Get.find<VideosController>();
//     ChapterController chapterController = Get.find<ChapterController>();
//     ClassesController classesController = Get.find<ClassesController>();
//     return AppBar(
//       backgroundColor: AppColors.white,
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(
//               Icons.close,
//             ),
//           ),
//           SizedBox(
//             width: 10,
//           ),
//           Column(
//             children: [
//               SizedBox(
//                 width: MediaQuery.of(context).size.width - 100,
//                 child: Text(
//                   videosController.videoName.value,
//                   // 'bksjdbk sjhdfkads fajdhgf dfjdhaf jhadsgfkjd fdjshgjkadsg dajfhdkjhf jadhfjhg jahdgfkhjadg fjhagsdfhga',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.urbanist(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 140,
//                 child: Row(
//                   children: [
//                     // Text(
//                     //   classesController.selectedSubject.subjectName,
//                     //   style: GoogleFonts.urbanist(fontSize: 12),
//                     // ),
//                     // Text(
//                     //   " - Chapter ${chapterController.selectedChapter.chapterNo}",
//                     //   style: GoogleFonts.urbanist(fontSize: 12),
//                     // ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//       scrolledUnderElevation: 0,
//       automaticallyImplyLeading: false,
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
