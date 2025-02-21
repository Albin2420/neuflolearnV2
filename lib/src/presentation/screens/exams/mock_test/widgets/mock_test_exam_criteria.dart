import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MocktestExamcriteria extends StatelessWidget {
  String? timeLimit;
  String noOfQuestion;
  String? negativeMark;
  MocktestExamcriteria(
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
      padding: EdgeInsets.only(
        top: 24,
        bottom: 24,
      ),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      // height: 24,
                      // width: 24,
                      child: Image.asset(scale: 4, "assets/icons/plus.png"),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          "+4",
                          style: GoogleFonts.urbanist(
                              color: Color(0xff02013B),
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        Text(
                          " for correct ans",
                          style: GoogleFonts.urbanist(
                              color: Color(0xff02013B),
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset(scale: 4, "assets/icons/minus.png"),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          "-1",
                          style: GoogleFonts.urbanist(
                              color: Color(0xff02013B),
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        Text(
                          " for incorrect ans",
                          style: GoogleFonts.urbanist(
                              color: Color(0xff02013B),
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
              ),
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
                    "solutions",
                    style: GoogleFonts.urbanist(
                        color: Color(0xff02013B),
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "at the end",
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
                    child: Image.asset(scale: 4, "assets/icons/menu.png"),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Row(
                    children: [
                      Text(
                        "Score",
                        style: GoogleFonts.urbanist(
                            color: Color(0xff02013B),
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        "at the end",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Image.asset(scale: 4, "assets/icons/skip.png"),
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                "skip",
                style: GoogleFonts.urbanist(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(" upto 20 questions")
            ],
          ),
        ],
      ),
    );
  }
}
