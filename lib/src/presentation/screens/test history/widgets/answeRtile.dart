import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

class AnsweRTile extends StatelessWidget {
  final String answer;
  final String qstn;
  final String opt;
  final String explanation;
  final String submittedAns;

  const AnsweRTile(
      {super.key,
      required this.answer,
      required this.qstn,
      required this.opt,
      required this.explanation,
      required this.submittedAns});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                GptMarkdown(
                  qstn,
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF010029),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GptMarkdown(
                  "Ans: $answer) $opt",
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF010029),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Explanation :",
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF010029),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                GptMarkdown(
                  explanation,
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF010029),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Text("submitted:$submittedAns : answer:$answer"),
                submittedAns != "unattempted"
                    ? Column(
                        children: [
                          Divider(
                            color: Color(0xff01002933).withValues(alpha: 0.2),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          submittedAns == answer
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      submittedAns,
                                      style: GoogleFonts.urbanist(
                                        color: const Color(0xFF010029),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child:
                                          Image.asset("assets/icons/done.png"),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          submittedAns,
                                          style: GoogleFonts.urbanist(
                                            color: const Color(0xFF010029),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Image.asset(
                                              "assets/icons/wrong.png"),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          answer,
                                          style: GoogleFonts.urbanist(
                                            color: const Color(0xFF010029),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Image.asset(
                                              "assets/icons/done.png"),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                        ],
                      )
                    : SizedBox(
                        height: 10,
                      ),
              ],
            ),
          ),
          submittedAns == "unattempted"
              ? Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF010029),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  height: 38,
                  child: Center(
                    child: Text(
                      'Un Attempted',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.kwhite,
                      ),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24)),
                    color: submittedAns == answer ? Colors.green : Colors.red,
                  ),
                  height: 38,
                  child: Center(
                    child: Text(
                      submittedAns == answer
                          ? "Correct answer"
                          : "Incorrect answer",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.kwhite,
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
