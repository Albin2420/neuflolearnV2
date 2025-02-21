import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Scoregrowthgraph extends StatelessWidget {
  final String score;
  const Scoregrowthgraph({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 24, bottom: 20, right: 24),
      height: 102,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
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
                // Obx(() {
                //   return Text(
                //     "${(ctr.stdataPracticeTest["average_score"] ?? 0).toInt()}",
                //     style: GoogleFonts.urbanist(
                //       fontWeight: FontWeight.w700,
                //       fontSize: 24,
                //     ),
                //   );
                // }),
                Text(
                  score,
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      "AVERAGE SCORE",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      height: 12,
                      width: 14,
                      child: Image.asset("assets/icons/book.png"),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "36%",
                      style: GoogleFonts.urbanist(
                        color: Color(0xff18AC00),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    SizedBox(
                      height: 8,
                      width: 8,
                      child: Center(
                        child: Image.asset("assets/icons/uparrow.png"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 3),
                        FlSpot(2, 1.5),
                        FlSpot(3, 2),
                        FlSpot(4, 4),
                        FlSpot(5, 3),
                        FlSpot(5, 3),
                        FlSpot(5, 3),
                        FlSpot(5, 3),
                      ],
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.red],
                      ),
                      isCurved: true,
                      color: Colors.green,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
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
