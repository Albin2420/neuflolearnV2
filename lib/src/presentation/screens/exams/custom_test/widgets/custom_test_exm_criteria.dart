import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomtestExamcriteria extends StatelessWidget {
  final bool shadow;
  final String? timeLimit;
  final String noOfQuestion;
  final String? negativeMark;
  const CustomtestExamcriteria({
    required this.shadow,
    this.timeLimit,
    required this.noOfQuestion,
    super.key,
    this.negativeMark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: shadow == false
            ? []
            : [
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                        scale: 4, "assets/icons/instant_solution.png"),
                  ),
                  SizedBox(
                    width: 3,
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
                    "evaluation",
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(scale: 4, "assets/icons/clock.png"),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "$timeLimit min",
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "time limit",
                    style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child:
                        Image.asset(scale: 4, "assets/icons/question_mark.png"),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    noOfQuestion,
                    style: GoogleFonts.urbanist(
                        color: Color(0xff02013B),
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "questions",
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(scale: 5, "assets/icons/menu.png"),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "score",
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "at the end",
                    style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
