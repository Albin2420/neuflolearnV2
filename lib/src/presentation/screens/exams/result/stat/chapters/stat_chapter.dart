import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/widgets/detail_summary_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StatChapter extends StatefulWidget {
  const StatChapter({super.key});

  @override
  State<StatChapter> createState() => _StatChapterState();
}

class _StatChapterState extends State<StatChapter> {
  bool physics = false;
  bool chemistery = true;
  bool biology = false;
  double index = 1;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Container(
                  padding: EdgeInsets.all(
                      Constant.screenWidth * (4 / Constant.figmaScreenWidth)),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: physics
                                ? const Color(0xFF010029)
                                : const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(128),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(128),
                              onTap: () async {
                                setState(() {
                                  physics = true;
                                  chemistery = false;
                                  biology = false;
                                  index = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(128),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          PhosphorIcons.atom(physics
                                              ? PhosphorIconsStyle.fill
                                              : PhosphorIconsStyle.regular),
                                          color: physics
                                              ? Colors.white
                                              : Colors.black,
                                          size: 15,
                                        ),
                                        Gap(
                                          Constant.screenWidth *
                                              (4 / Constant.figmaScreenWidth),
                                        ),
                                        Text(
                                          "Physics",
                                          style: GoogleFonts.urbanist(
                                            fontSize: Constant.screenHeight *
                                                (14 /
                                                    Constant.figmaScreenHeight),
                                            fontWeight: FontWeight.w400,
                                            color: physics
                                                ? const Color(0xFFFFFFFF)
                                                : const Color(0xFF010029),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(128),
                            color: chemistery
                                ? const Color(0xFF010029)
                                : const Color(0xFFFFFFFF),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(128),
                              onTap: () {
                                setState(() {
                                  physics = false;
                                  chemistery = true;
                                  biology = false;
                                  index = 1;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(128),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          PhosphorIcons.flask(chemistery
                                              ? PhosphorIconsStyle.fill
                                              : PhosphorIconsStyle.regular),
                                          color: chemistery
                                              ? Colors.white
                                              : Colors.black,
                                          size: 15,
                                        ),
                                        Gap(
                                          Constant.screenWidth *
                                              (4 / Constant.figmaScreenWidth),
                                        ),
                                        Text(
                                          "Chemistry",
                                          style: GoogleFonts.urbanist(
                                            fontSize: Constant.screenHeight *
                                                (14 /
                                                    Constant.figmaScreenHeight),
                                            fontWeight: FontWeight.w400,
                                            color: chemistery
                                                ? const Color(0xFFFFFFFF)
                                                : const Color(0xFF010029),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: biology
                                ? const Color(0xFF010029)
                                : const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(128),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(128),
                              onTap: () {
                                setState(() {
                                  physics = false;
                                  chemistery = false;
                                  biology = true;
                                  index = 2;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(128),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          PhosphorIcons.stethoscope(biology
                                              ? PhosphorIconsStyle.fill
                                              : PhosphorIconsStyle.regular),
                                          color: biology
                                              ? Colors.white
                                              : Colors.black,
                                          size: 15,
                                        ),
                                        Gap(
                                          Constant.screenWidth *
                                              (4 / Constant.figmaScreenWidth),
                                        ),
                                        Text(
                                          "Biology",
                                          style: GoogleFonts.urbanist(
                                            fontSize: Constant.screenHeight *
                                                (14 /
                                                    Constant.figmaScreenHeight),
                                            fontWeight: FontWeight.w400,
                                            color: biology
                                                ? const Color(0xFFFFFFFF)
                                                : const Color(0xFF010029),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 222,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Problem areas",
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 36,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Electric currents or sum shih its a looooooooooongggsggsgsg",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.urbanist(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          "60% incorrect",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: AppColors.kred,
                                          ),
                                        )
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(48),
                                      backgroundColor: Color(0xffD84040)
                                          .withValues(alpha: 0.2),
                                      valueColor:
                                          AlwaysStoppedAnimation<Color?>(
                                              Color(0xffD84040)),
                                      value: 0.6,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                height: 36,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Electric currents or sum shih its a looooooooooongggsggsgsg",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.urbanist(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          "60% incorrect",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: AppColors.kred,
                                          ),
                                        )
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(48),
                                      backgroundColor: Color(0xffD84040)
                                          .withValues(alpha: 0.2),
                                      valueColor:
                                          AlwaysStoppedAnimation<Color?>(
                                              Color(0xffD84040)),
                                      value: 0.4,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                height: 36,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Electric currents or sum shih its a looooooooooongggsggsgsg",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.urbanist(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          "60% incorrect",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: AppColors.kred,
                                          ),
                                        )
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(48),
                                      backgroundColor: Color(0xffD84040)
                                          .withValues(alpha: 0.2),
                                      valueColor:
                                          AlwaysStoppedAnimation<Color?>(
                                              Color(0xffD84040)),
                                      value: 0.3,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 222,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Strengths ",
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 36,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Electric currents or sum shih its a looooooooooongggsggsgsg",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.urbanist(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          "60% correct",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: AppColors.kgreen,
                                          ),
                                        )
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(48),
                                      backgroundColor: Color(0xff18AC00)
                                          .withValues(alpha: 0.2),
                                      valueColor:
                                          AlwaysStoppedAnimation<Color?>(
                                              Color(0xff18AC00)),
                                      value: 0.6,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                height: 36,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Electric currents or sum shih its a looooooooooongggsggsgsg",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.urbanist(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          "60% correct",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: AppColors.kgreen,
                                          ),
                                        )
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(48),
                                      backgroundColor: Color(0xff18AC00)
                                          .withValues(alpha: 0.2),
                                      valueColor:
                                          AlwaysStoppedAnimation<Color?>(
                                              Color(0xff18AC00)),
                                      value: 0.4,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                height: 36,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Electric currents or sum shih its a looooooooooongggsggsgsg",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.urbanist(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          "60% correct",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: AppColors.kgreen,
                                          ),
                                        )
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(48),
                                      backgroundColor: Color(0xff18AC00)
                                          .withValues(alpha: 0.2),
                                      valueColor:
                                          AlwaysStoppedAnimation<Color?>(
                                              Color(0xff18AC00)),
                                      value: 0.3,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextBtn(
                    text: 'View detailed summary',
                    onTap: () {
                      log("oooi");
                    },
                  ),
                  SizedBox(
                    height: 22,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
