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
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    getFormattedDateFromString(testDate),
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
                    scale: 4.5,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String getFormattedDateFromString(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final day = date.day;
      final suffix = _getDaySuffix(day);
      final month = _monthNames[date.month - 1];
      return '$day$suffix $month';
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
}
