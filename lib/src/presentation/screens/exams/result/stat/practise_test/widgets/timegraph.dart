import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

class TimeGrowthGraph extends StatelessWidget {
  final double seconds;
  final Map<String, dynamic> map; // Expecting a dynamic map for data
  final double timegrowthPercentage;

  const TimeGrowthGraph(
      {super.key,
      required this.seconds,
      required this.map,
      required this.timegrowthPercentage});

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
      padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20, right: 24),
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
                      RichText(
                        text: TextSpan(
                          text: "$hrs", // The number
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w700,
                            fontSize: 24, // Larger size for number
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: " hr", // The suffix "sec"
                              style: GoogleFonts.urbanist(
                                fontWeight:
                                    FontWeight.w400, // Regular weight for "sec"
                                fontSize: 10, // Smaller font size for "sec"
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                    ],
                    if (mins > 0) ...[
                      RichText(
                        text: TextSpan(
                          text: "$mins", // The number
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w700,
                            fontSize: 24, // Larger size for number
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: " min", // The suffix "sec"
                              style: GoogleFonts.urbanist(
                                fontWeight:
                                    FontWeight.w400, // Regular weight for "sec"
                                fontSize: 10, // Smaller font size for "sec"
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                    ],
                    RichText(
                      text: TextSpan(
                        text: "$secs", // The number
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w700,
                          fontSize: 24, // Larger size for number
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: " sec", // The suffix "sec"
                            style: GoogleFonts.urbanist(
                              fontWeight:
                                  FontWeight.w400, // Regular weight for "sec"
                              fontSize: 10, // Smaller font size for "sec"
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
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
                      "${timegrowthPercentage.toStringAsFixed(1)}%",
                      style: GoogleFonts.urbanist(
                        color: timegrowthPercentage <= 0
                            ? AppColors.kred
                            : const Color(0xff18AC00),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 2),
                    SizedBox(
                      height: 8,
                      width: 8,
                      child: Center(
                        child: Image.asset(timegrowthPercentage <= 0
                            ? "assets/icons/down_arrow.png"
                            : "assets/icons/uparrow.png"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 10, left: 6),
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
