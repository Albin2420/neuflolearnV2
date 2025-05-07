import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';

class VideoListtile extends StatelessWidget {
  final int index;
  final VoidCallback onTap;
  final String title;
  final String subTitle;

  const VideoListtile({
    super.key,
    required this.index,
    required this.onTap,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 106,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/girl.png',
                    width: 120,
                    height: 100,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 25,
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/arrow_right.png',
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 160,
                right: 0,
                top: 32,
                bottom: 32,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  height: 100,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.completedTextArrowColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/core/config/theme/colors.dart';
// import 'package:neuflo_learn/src/presentation/controller/videos/videos_controller.dart';

// class VideoListtile extends StatelessWidget {
//   final int index;
//   final VoidCallback onTap;
//   final String title;
//   final String subTitle;

//   const VideoListtile({
//     super.key,
//     required this.index,
//     required this.onTap,
//     required this.title,
//     required this.subTitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     VideosController videosController = Get.find<VideosController>();

//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           height: 106,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 20),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Image.asset(
//                     'assets/images/girl.png',
//                     width: 120,
//                     height: 100,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 20,
//                 left: 25,
//                 child: Container(
//                   height: 32,
//                   width: 32,
//                   decoration: BoxDecoration(
//                     color: AppColors.orange,
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey,
//                         spreadRadius: 1,
//                         blurRadius: 4,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Image.asset(
//                       'assets/images/arrow_right.png',
//                       width: 15,
//                       height: 15,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 160,
//                 right: 0,
//                 top: 32,
//                 bottom: 32,
//                 child: Text(
//                   videosController.videoLessons.isNotEmpty
//                       ? videosController.videoLessons[index]['title'] ??
//                           "Untitled"
//                       : "Loading...",
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 2,
//                   style: GoogleFonts.urbanist(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: 0,
//                 child: Container(
//                   height: 100,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     Icons.arrow_forward_ios,
//                     color: AppColors.completedTextArrowColor,
//                     size: 18,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
