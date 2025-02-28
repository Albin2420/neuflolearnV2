import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class ProfileStatsWidget extends StatelessWidget {
  final double toTalPercentage;
  final double sec;
  final Map<String, double> dataMap;

  const ProfileStatsWidget(
      {super.key,
      required this.sec,
      required this.dataMap,
      required this.toTalPercentage});

  String getFormattedTime(double seconds) {
    int hours = (seconds ~/ 3600);
    int minutes = ((seconds % 3600) ~/ 60);
    return "${hours}h ${minutes}m";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = screenWidth * 0.9;
    double containerHeight = screenHeight * 0.5;

    List<Color> colorList = [
      const Color(0xFF21A2FF),
      const Color(0xFFFF7F21),
      const Color(0xFF9747FF),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: containerHeight,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "This week's Learning",
                  style: GoogleFonts.urbanist(
                    textStyle: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                Text(
                  getFormattedTime(sec), // Dynamically formatted time
                  style: GoogleFonts.urbanist(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  "Oh Good Keep Going!",
                  style: GoogleFonts.urbanist(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                Expanded(
                  child: PieChart(
                    dataMap: dataMap,
                    ringStrokeWidth: 25,
                    colorList: colorList,
                    chartType: ChartType.ring,
                    chartRadius: MediaQuery.of(context).size.width / 2,
                    centerText: '$toTalPercentage%',
                    centerTextStyle: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    )),
                    legendOptions: const LegendOptions(
                      showLegends: false,
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValues: false,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF21A2FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'PHY',
                      style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          color: Color(0xFF21A2FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7F21),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'CHE',
                      style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          color: Color(0xFFFF7F21),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9747FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'BIO',
                      style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          color: Color(0xFF9747FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
