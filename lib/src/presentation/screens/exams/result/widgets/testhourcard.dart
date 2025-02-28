import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Testhourcard extends StatelessWidget {
  final String testAttended;
  final double seconds;

  const Testhourcard({
    super.key,
    required this.testAttended,
    required this.seconds,
  });

  // Function to calculate hours
  String getHours(double totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    return hours > 0 ? '$hours' : ''; // Return empty string if 0
  }

  // Function to calculate minutes
  String getMinutes(double totalSeconds) {
    int minutes = ((totalSeconds % 3600) ~/ 60);
    return (minutes > 0 || getHours(totalSeconds).isNotEmpty)
        ? '$minutes'
        : '0';
  }

  @override
  Widget build(BuildContext context) {
    String hours = getHours(seconds);
    String minutes = getMinutes(seconds);

    log("seconds in Testhourcard():$seconds");

    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 2),
            blurRadius: 5.8,
            spreadRadius: 0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      height: 82,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      testAttended,
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      "TESTS TAKEN",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: const Color(0xff02012A).withOpacity(0.5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 2,
            color: const Color(0xff02012a1a).withOpacity(0.1),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hours.isNotEmpty) ...[
                          Text(
                            hours,
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "hr",
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: const Color(0xff02013d80).withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          minutes,
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "min",
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: const Color.fromARGB(2, 3, 64, 134)
                                .withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "TOTAL TIME SPENT",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: const Color(0xff02012A).withOpacity(0.5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
