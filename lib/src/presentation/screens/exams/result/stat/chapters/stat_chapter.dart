import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/teststatus/test_status_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/chapters/widgets/problem_area_topics.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/chapters/widgets/strength_area_topics.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StatChapter extends StatelessWidget {
  const StatChapter({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<TestStatusController>();
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Obx(() {
          return Padding(
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
                          color: ctr.chapIndex.value == 0
                              ? const Color(0xFF010029)
                              : const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(128),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(128),
                            onTap: () async {
                              ctr.changeChapIndex(index: 0);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(128),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        PhosphorIcons.atom(
                                            ctr.chapIndex.value == 0
                                                ? PhosphorIconsStyle.fill
                                                : PhosphorIconsStyle.regular),
                                        color: ctr.chapIndex.value == 0
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
                                              (14 / Constant.figmaScreenHeight),
                                          fontWeight: FontWeight.w400,
                                          color: ctr.chapIndex.value == 0
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
                          color: ctr.chapIndex.value == 1
                              ? const Color(0xFF010029)
                              : const Color(0xFFFFFFFF),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(128),
                            onTap: () {
                              ctr.changeChapIndex(index: 1);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(128),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        PhosphorIcons.flask(
                                            ctr.chapIndex.value == 1
                                                ? PhosphorIconsStyle.fill
                                                : PhosphorIconsStyle.regular),
                                        color: ctr.chapIndex.value == 1
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
                                              (14 / Constant.figmaScreenHeight),
                                          fontWeight: FontWeight.w400,
                                          color: ctr.chapIndex.value == 1
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
                          color: ctr.chapIndex.value == 2
                              ? const Color(0xFF010029)
                              : const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(128),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(128),
                            onTap: () {
                              ctr.changeChapIndex(index: 2);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(128),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        PhosphorIcons.stethoscope(
                                            ctr.chapIndex.value == 2
                                                ? PhosphorIconsStyle.fill
                                                : PhosphorIconsStyle.regular),
                                        color: ctr.chapIndex.value == 2
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
                                              (14 / Constant.figmaScreenHeight),
                                          fontWeight: FontWeight.w400,
                                          color: ctr.chapIndex.value == 2
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
          );
        }),
        Obx(() {
          final selectedList = ctr.chapIndex.value == 0
              ? ctr.physics
              : ctr.chapIndex.value == 1
                  ? ctr.chemistry
                  : ctr.biology;

          if (selectedList.isEmpty) {
            return SizedBox(
                // color: Colors.red,
                height: MediaQuery.of(context).size.height / 2,
                child: Center(child: Text("No History is Available")));
          }

          return Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            width: MediaQuery.of(context).size.width,
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
                const SizedBox(height: 24),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: selectedList.length,
                  itemBuilder: (context, index) {
                    final topic = selectedList.keys.elementAt(index);
                    final percentage =
                        selectedList[topic]["incorrect_percentage"] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: ProblemAreaTopics(
                        toPic: topic,
                        inCRCpercentage: percentage,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  "Strengths",
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: selectedList.length,
                  itemBuilder: (context, index) {
                    final topic = selectedList.keys.elementAt(index);
                    final percentage =
                        selectedList[topic]["correct_percentage"] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: StrengthAreaTopics(
                        toPic: topic,
                        cRCpercentage: percentage,
                      ),
                    );
                  },
                ),
                // const SizedBox(height: 30),
                // CustomTextBtn(
                //   text: 'View detailed summary',
                //   onTap: () {},
                // ),
                // const SizedBox(height: 22),
              ],
            ),
          );
        }),
      ],
    ));
  }
}
