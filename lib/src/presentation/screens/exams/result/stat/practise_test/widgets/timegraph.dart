// import 'dart:developer';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/core/config/theme/colors.dart';

// class TimeGrowthGraph extends StatelessWidget {
//   final double seconds;
//   final dynamic map;
//   const TimeGrowthGraph({super.key, required this.seconds, required this.map});

//   @override
//   Widget build(BuildContext context) {
//     log("second TimeGrowthGraph():$seconds");
//     log("map:$map");
//     int hrs = (seconds ~/ 3600);
//     int mins = ((seconds % 3600) ~/ 60);
//     int secs = (seconds % 60).toInt();

//     return Container(
//       padding: EdgeInsets.only(top: 20, left: 24, bottom: 20, right: 24),
//       height: 102,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x0F000000),
//             offset: Offset(0, 2),
//             blurRadius: 5.8,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     if (hrs > 0) ...[
//                       Text(
//                         "$hrs",
//                         style: GoogleFonts.urbanist(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 24,
//                         ),
//                       ),
//                       SizedBox(width: 3),
//                       Text(
//                         'hr',
//                         style: GoogleFonts.urbanist(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 10,
//                         ),
//                       ),
//                       SizedBox(width: 3),
//                     ],
//                     if (mins > 0) ...[
//                       Text(
//                         "$mins",
//                         style: GoogleFonts.urbanist(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 24,
//                         ),
//                       ),
//                       SizedBox(width: 3),
//                       Text(
//                         'min',
//                         style: GoogleFonts.urbanist(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 10,
//                         ),
//                       ),
//                       SizedBox(width: 3),
//                     ],
//                     Text(
//                       "$secs",
//                       style: GoogleFonts.urbanist(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 24,
//                       ),
//                     ),
//                     SizedBox(width: 3),
//                     Text(
//                       "sec",
//                       style: GoogleFonts.urbanist(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 10,
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Text(
//                       "AVERAGE TIME",
//                       style: GoogleFonts.urbanist(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 10,
//                       ),
//                     ),
//                     SizedBox(width: 4),
//                     SizedBox(
//                       height: 12,
//                       width: 14,
//                       child: Image.asset("assets/icons/timer4.png"),
//                     ),
//                     SizedBox(width: 5),
//                     Text(
//                       "10%",
//                       style: GoogleFonts.urbanist(
//                         color: AppColors.kred,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 10,
//                       ),
//                     ),
//                     SizedBox(width: 2),
//                     SizedBox(
//                       height: 8,
//                       width: 8,
//                       child: Center(
//                         child: Image.asset("assets/icons/down_arrow.png"),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//           SizedBox(width: 2),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.only(bottom: 10),
//               child: LineChart(
//                 LineChartData(
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: [
//                         FlSpot(0, 2),
//                         FlSpot(1, 2.2),
//                         FlSpot(2, 2.5),
//                         FlSpot(3, 80),
//                         FlSpot(4, 20),
//                         FlSpot(5, 100),
//                         FlSpot(6, 2.8),
//                         FlSpot(7, 2.6),
//                         FlSpot(8, 2.5)
//                       ],
//                       gradient: LinearGradient(
//                         colors: [Colors.red, Colors.red],
//                       ),
//                       isCurved: true,
//                       color: Colors.green,
//                       belowBarData: BarAreaData(show: false),
//                       dotData: FlDotData(show: false),
//                     ),
//                   ],
//                   gridData: FlGridData(show: false),
//                   titlesData: FlTitlesData(show: false),
//                   borderData: FlBorderData(show: false),
//                   lineTouchData: LineTouchData(enabled: false),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

class TimeGrowthGraph extends StatelessWidget {
  final double seconds;
  final Map<String, dynamic> map; // Expecting a dynamic map for data

  const TimeGrowthGraph({super.key, required this.seconds, required this.map});

  @override
  Widget build(BuildContext context) {
    log("second TimeGrowthGraph(): $seconds");
    log("map: $map");

    int hrs = (seconds ~/ 3600);
    int mins = ((seconds % 3600) ~/ 60);
    int secs = (seconds % 60).toInt();

    // Convert map values to a list of FlSpot dynamically
    List<FlSpot> spots = [];
    int index = 0;
    map.forEach((key, value) {
      if (value is num) {
        spots.add(FlSpot(index.toDouble(), value.toDouble()));
      }
      index++;
    });

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 24, bottom: 20, right: 24),
      height: 102,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 5.8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (hrs > 0) ...[
                      Text(
                        "$hrs",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'hr',
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 3),
                    ],
                    if (mins > 0) ...[
                      Text(
                        "$mins",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'min',
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 3),
                    ],
                    Text(
                      "$secs",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      "sec",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "AVERAGE TIME",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      height: 12,
                      width: 14,
                      child: Image.asset("assets/icons/timer4.png"),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "10%",
                      style: GoogleFonts.urbanist(
                        color: AppColors.kred,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 2),
                    SizedBox(
                      height: 8,
                      width: 8,
                      child: Center(
                        child: Image.asset("assets/icons/down_arrow.png"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots, // **Using dynamic Y-axis data from map**
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.red],
                      ),
                      isCurved: true,
                      color: Colors.green,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 30,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: false), // **Hiding X-axis**
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(enabled: false),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
