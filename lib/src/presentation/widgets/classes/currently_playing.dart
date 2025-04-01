// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/core/config/theme/colors.dart';
// import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';

// class LiveSection extends StatelessWidget {
//   final String title;
//   final Color color;
//   final String time;
//   final VoidCallback onTapCallback; // The callback parameter

//   // Updated constructor to include the callback
//   const LiveSection({
//     super.key,
//     required this.title,
//     required this.color,
//     required this.time,
//     required this.onTapCallback, // Accept callback here
//   });

//   @override
//   Widget build(BuildContext context) {
//     ClassesController classesController = Get.find<ClassesController>();

//     return GestureDetector(
//       onTap: () => onTapCallback(),
//       child: Container(
//         height: 90,
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Use Expanded to ensure the title and time fit within available space
//             Expanded(
//               child: Container(
//                 height: 90,
//                 decoration: BoxDecoration(
//                   color: color,
//                   borderRadius: BorderRadius.circular(18),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.urbanist(
//                           fontSize: 19,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         children: [
//                           SizedBox(
//                             height: 18,
//                             width: 18,
//                             child: Image.asset(
//                               'assets/images/union.png',
//                               filterQuality: FilterQuality.high,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             "$time pm",
//                             style: GoogleFonts.urbanist(
//                                 fontSize: 16, color: AppColors.timeTextColor),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Arrow icon wrapped in a Container with a fixed size
//             Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: Container(
//                 alignment: Alignment.center,
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                     color: AppColors.orange,
//                     borderRadius: BorderRadius.circular(30)),
//                 child: Image.asset(
//                   'assets/images/arrow_right.png',
//                   height: 20,
//                   width: 22,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';

class LiveSection extends StatelessWidget {
  final String title;
  final Color color;
  final String time; // The time in '2025-03-28T22:00:00' format
  final VoidCallback onTapCallback;

  const LiveSection({
    super.key,
    required this.title,
    required this.color,
    required this.time,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the time string into a DateTime object
    DateTime parsedTime = DateTime.parse(time);

    // Format the time in 12-hour format with AM/PM
    String formattedTime = DateFormat.jm().format(parsedTime);

    // For example: '10:00 PM'

    ClassesController classesController = Get.find<ClassesController>();

    return GestureDetector(
      onTap: () => onTapCallback(),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.urbanist(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 18,
                            width: 18,
                            child: Image.asset(
                              'assets/images/union.png',
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            formattedTime, // Display the formatted time
                            style: GoogleFonts.urbanist(
                                fontSize: 16, color: AppColors.timeTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(30)),
                child: Image.asset(
                  'assets/images/arrow_right.png',
                  height: 20,
                  width: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
