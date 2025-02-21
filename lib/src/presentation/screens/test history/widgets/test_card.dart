// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TestCard extends StatelessWidget {
//   final String testName;
//   final String testDate;
//   final int currentScore;
//   final int totalScore;
//   const TestCard(
//       {super.key,
//       required this.currentScore,
//       required this.totalScore,
//       required this.testName,
//       required this.testDate});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 8),
//       height: 78,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, 1),
//             blurRadius: 1,
//             spreadRadius: 0,
//             color: Colors.black.withOpacity(0.08),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(
//                   testName,
//                   style: GoogleFonts.urbanist(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Color(0xff010029),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Expanded(
//                 child: Text(
//                   testDate,
//                   overflow: TextOverflow.fade,
//                   style: GoogleFonts.urbanist(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14,
//                     color: Color(0xff010029),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         "$currentScore",
//                         style: GoogleFonts.urbanist(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                           color: Color(0xff02013D),
//                         ),
//                       ),
//                       Text(
//                         '/$totalScore',
//                         style: GoogleFonts.urbanist(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 12,
//                           color: Color(0xff02013D),
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     "SCORE",
//                     style: GoogleFonts.urbanist(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 10,
//                       color: Color(0xff02013D),
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 width: 4,
//               ),
//               SizedBox(
//                 width: 35,
//                 child: Image.asset(
//                   "assets/icons/right.png",
//                   scale: 3.5,
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestCard extends StatelessWidget {
  final String testName;
  final String testDate;
  final int currentScore;
  final int totalScore;
  final VoidCallback? onTap; // Added onTap callback

  const TestCard({
    super.key,
    required this.currentScore,
    required this.totalScore,
    required this.testName,
    required this.testDate,
    this.onTap, // Optional onTap function
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // GestureDetector handles taps
      child: Container(
        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 8),
        height: 78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0,
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    testName,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color(0xff010029),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    testDate,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: const Color(0xff010029),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "$currentScore",
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: const Color(0xff02013D),
                          ),
                        ),
                        Text(
                          '/$totalScore',
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: const Color(0xff02013D),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "SCORE",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: const Color(0xff02013D),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 35,
                  child: Image.asset(
                    "assets/icons/right.png",
                    scale: 3.5,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
