import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/widgets/progressBar.dart';

class ProgressGraphtile extends StatelessWidget {
  final Map<String, dynamic>? weekdata;
  final double maxLimit; // Max limit in seconds

  const ProgressGraphtile({
    super.key,
    required this.weekdata,
    required this.maxLimit,
  });

  String formatTime(double? seconds) {
    if (seconds == null || seconds <= 0) return "0 min";

    int hours = (seconds ~/ 3600);
    int minutes = ((seconds % 3600) ~/ 60);

    List<String> parts = [];
    if (hours > 0) parts.add("$hours hr");
    if (minutes > 0 || hours == 0) {
      parts.add("$minutes min");
    }

    return parts.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    log("weekData in : $weekdata");

    bool isDataInvalid = weekdata == null || weekdata!.isEmpty || maxLimit == 0;

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
              children: (weekdata?.entries ??
                      List.generate(7, (index) => MapEntry("Day$index", 0.0)))
                  .map((entry) {
                double seconds = isDataInvalid
                    ? 0.0
                    : (entry.value as num?)?.toDouble() ?? 0.0;
                double progress =
                    maxLimit > 0 ? (seconds / maxLimit).clamp(0.0, 1.0) : 0.0;

                log("Day: ${entry.key}, Time: $seconds sec, Progress: $progress");

                return Column(
                  children: [
                    CustomPaint(
                      size: const Size(30, 200),
                      painter: ProgressBarPainter(
                        progress: progress,
                        text: formatTime(seconds),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.key.substring(0, 3).toUpperCase(),
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
