import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

class AnswerTile extends StatelessWidget {
  final String qID;
  final String answer;
  final String correctAnswer;
  final String incorrectAnswer;
  const AnswerTile({
    super.key,
    required this.qID,
    required this.answer,
    required this.correctAnswer,
    required this.incorrectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    log({
      "in AnswerTile :$qID",
      "answer:$answer",
      "correctAnswer:$correctAnswer",
      "incorrectAnswer:$incorrectAnswer"
    }.toString());
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
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // LaTexT(
                //   laTeXCode: Text(
                //     answer,
                //     style: GoogleFonts.urbanist(
                //       color: const Color(0xFF010029),
                //       fontWeight: FontWeight.w700,
                //       fontSize: 16,
                //     ),
                //   ),
                // ),
                GptMarkdown(
                  answer,
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF010029),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                incorrectAnswer == 'null'
                    ? SizedBox()
                    : Column(
                        children: [
                          Divider(
                            color: Color(0xff01002933).withValues(alpha: 0.2),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    //   child: Center(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         SizedBox(
                    //           height: 24,
                    //           width: 24,
                    //           child: Image.asset("assets/icons/done.png"),
                    //         ),
                    //         SizedBox(
                    //           width: 8,
                    //         ),
                    //         Text(
                    //           correctAnswer,
                    //           style: GoogleFonts.urbanist(
                    //             fontWeight: FontWeight.w600,
                    //             fontSize: 16,
                    //             color: AppColors.KTextColorGreenLight,
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            incorrectAnswer == 'null'
                                ? SizedBox()
                                : SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: correctAnswer == incorrectAnswer
                                        ? Image.asset("assets/icons/done.png")
                                        : Image.asset("assets/icons/wrong.png"),
                                  ),
                            SizedBox(
                              width: 8,
                            ),
                            incorrectAnswer == 'null'
                                ? SizedBox()
                                : GptMarkdown(
                                    incorrectAnswer,
                                    style: GoogleFonts.urbanist(
                                      color: const Color(0xFF010029),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          incorrectAnswer == 'null'
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
                    color: correctAnswer == incorrectAnswer
                        ? Colors.green
                        : Colors.red,
                  ),
                  height: 38,
                  child: Center(
                    child: Text(
                      correctAnswer == incorrectAnswer
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
