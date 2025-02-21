// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/widgets/progressBar.dart';

// class ProgressGraphtile extends StatelessWidget {
//   final Map<String, dynamic> weekdata;
//   const ProgressGraphtile({super.key, required this.weekdata});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(24),
//       height: 322,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Time spent practising this week",
//             style: GoogleFonts.urbanist(
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//               color: Color(0xff02012a),
//             ),
//           ),
//           SizedBox(
//             height: 24,
//           ),
//           SizedBox(
//             width: double.infinity,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     CustomPaint(
//                       size: Size(30, 200),
//                       painter: ProgressBarPainter(progress: 0.8, text: '2.3'),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       "MON",
//                       style: GoogleFonts.urbanist(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 10,
//                       ),
//                     )
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     CustomPaint(
//                       size: Size(30, 200),
//                       painter: ProgressBarPainter(progress: 0.9, text: '2.3'),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       "TUE",
//                       style: GoogleFonts.urbanist(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 10,
//                       ),
//                     )
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     CustomPaint(
//                       size: Size(30, 200),
//                       painter: ProgressBarPainter(progress: 0.6, text: '2.3'),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       "WED",
//                       style: GoogleFonts.urbanist(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 10,
//                       ),
//                     )
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     CustomPaint(
//                       size: Size(30, 200),
//                       painter: ProgressBarPainter(progress: 0.4, text: '2.3'),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       "THU",
//                       style: GoogleFonts.urbanist(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 10,
//                       ),
//                     )
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     CustomPaint(
//                       size: Size(30, 200),
//                       painter: ProgressBarPainter(progress: 0.9, text: '2.3'),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       "FRI",
//                       style: GoogleFonts.urbanist(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 10,
//                       ),
//                     )
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     CustomPaint(
//                       size: Size(30, 200),
//                       painter: ProgressBarPainter(progress: 0.6, text: '2.3'),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       "SAT",
//                       style: GoogleFonts.urbanist(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 10,
//                       ),
//                     )
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     CustomPaint(
//                       size: Size(30, 200),
//                       painter: ProgressBarPainter(progress: 0.9, text: '2.3'),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       "SUN",
//                       style: GoogleFonts.urbanist(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 10,
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/widgets/progressBar.dart';

class ProgressGraphtile extends StatelessWidget {
  final Map<String, dynamic> weekdata;
  const ProgressGraphtile({super.key, required this.weekdata});

  String formatTime(double seconds) {
    int hours = (seconds ~/ 3600);
    int minutes = ((seconds % 3600) ~/ 60);

    // Round up minutes if there are remaining seconds
    if (seconds % 60 > 0) {
      minutes++;
    }

    List<String> parts = [];
    if (hours > 0) parts.add("$hours hr");
    if (minutes > 0) parts.add("$minutes min");

    return parts.isEmpty ? "0 min" : parts.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: 322,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Time spent practising this week",
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: const Color(0xff02012a),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weekdata.entries.map((entry) {
                log("double:${entry.value}");
                return Column(
                  children: [
                    CustomPaint(
                      size: const Size(30, 200),
                      painter: ProgressBarPainter(
                        progress: 0.3, // Fixed progress for all
                        text: formatTime(entry.value.toDouble()),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.key
                          .substring(0, 3)
                          .toUpperCase(), // Short form of the day
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
