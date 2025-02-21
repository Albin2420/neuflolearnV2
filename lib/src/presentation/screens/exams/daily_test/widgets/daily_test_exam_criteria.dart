import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailytestExamcriteria extends StatelessWidget {
  String? timeLimit;
  String noOfQuestion;
  String? negativeMark;
  DailytestExamcriteria(
      {this.timeLimit,
      required this.noOfQuestion,
      super.key,
      this.negativeMark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(scale: 4, "assets/icons/clock.png"),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  timeLimit == null
                      ? Row(
                          children: [
                            Text(
                              'No',
                              style: GoogleFonts.urbanist(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              " time limit",
                              style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            )
                          ],
                        )
                      : Text(
                          '$timeLimit',
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child:
                        Image.asset(scale: 4, "assets/icons/question_mark.png"),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    noOfQuestion,
                    style: GoogleFonts.urbanist(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    " questions",
                    style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                        scale: 4, "assets/icons/instant_solution.png"),
                  ),
                  Text(
                    "Instant",
                    style: GoogleFonts.urbanist(
                        color: Color(0xff02013B),
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "solutions",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(scale: 4, "assets/icons/negative.png"),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  negativeMark == null
                      ? Row(
                          children: [
                            Text(
                              "No",
                              style: GoogleFonts.urbanist(
                                  color: Color(0xff02013B),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "negative marking",
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "$negativeMark",
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
