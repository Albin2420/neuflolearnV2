import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultInfo extends StatefulWidget {
  final String timeTaken;
  final String sCore;
  final String rAnk;
  final String correct;
  final String unAttempted;
  final String incorrect;
  final String perCentage;
  const ResultInfo({
    super.key,
    required this.timeTaken,
    required this.sCore,
    required this.rAnk,
    required this.correct,
    required this.incorrect,
    required this.unAttempted,
    required this.perCentage,
  });

  @override
  State<ResultInfo> createState() => _ResultInfoState();
}

class _ResultInfoState extends State<ResultInfo> {
  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        value: double.parse(widget.correct),
        color: Color(0xff18AC00), // Outer red portion
        title: '',
        radius: 13,
      ),
      PieChartSectionData(
        value: double.parse(widget.unAttempted),
        color: Color(0xffFF6C00), // Outer yellow portion
        title: '',
        radius: 13,
      ),
      PieChartSectionData(
        value: double.parse(widget.incorrect),
        color: Color(0xffd84040), // Outer yellow portion
        title: '',
        radius: 13,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 5.8,
            spreadRadius: 0,
          ),
        ],
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Color(0xff0000001a).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
            ),
            height: 46,
            child: Text(
              "Your results",
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF010029).withValues(alpha: 0.5),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
            height: 102,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.timeTaken,
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Time taken",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.sCore,
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                              color: Color(0xff18AC00)),
                        ),
                      ),
                      Text(
                        "score",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "AIR ${widget.rAnk}",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "EST. RANK",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Divider(),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 10),
            height: 156,
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: Center(
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            sections: showingSections(),
                            borderData: FlBorderData(show: false),
                            centerSpaceRadius: 36,
                            centerSpaceColor: Colors.white,
                          ),
                        ),
                        Center(
                          child: Text(
                            "${widget.perCentage}%",
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Color(0xff18AC00),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 32, bottom: 40, right: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Correct",
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xff18AC00),
                              ),
                            ),
                            Text(
                              widget.correct,
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xff18AC00),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Unattempted",
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xffFF6C00),
                              ),
                            ),
                            Text(
                              widget.unAttempted,
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xffFF6C00),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Incorrect",
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xffD84040),
                              ),
                            ),
                            Text(
                              widget.incorrect,
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xffD84040),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
