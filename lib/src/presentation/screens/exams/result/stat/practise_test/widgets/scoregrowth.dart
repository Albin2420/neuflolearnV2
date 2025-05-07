import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

class Scoregrowthgraph extends StatelessWidget {
  final String score;
  final Map<String, dynamic> map; // Dynamic map for handling data
  final double scorePercentage;

  const Scoregrowthgraph({
    super.key,
    required this.score,
    required this.map,
    required this.scorePercentage,
  });

  @override
  Widget build(BuildContext context) {
    log("map: $map");

    // Convert map values to a list of FlSpot with indices as X values
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
        boxShadow: [
          const BoxShadow(
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
                Text(
                  score,
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "AVERAGE SCORE",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const SizedBox(
                      height: 12,
                      width: 14,
                      child: Image(image: AssetImage("assets/icons/book.png")),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${scorePercentage.toStringAsFixed(1)} %",
                      style: GoogleFonts.urbanist(
                        color: scorePercentage <= 0
                            ? AppColors.kred
                            : const Color(0xff18AC00),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    // const SizedBox(width: 2),
                    SizedBox(
                      height: 8,
                      width: 8,
                      child: Center(
                        child: Image.asset(
                          scorePercentage <= 0
                              ? "assets/icons/down_arrow.png"
                              : "assets/icons/uparrow.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 10, left: 12),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.red],
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
                      sideTitles: SideTitles(showTitles: false), // Hide X-axis
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
          ),
        ],
      ),
    );
  }
}
