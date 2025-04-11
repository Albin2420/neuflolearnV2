import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/controller/home/home_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/custom_exam_view.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/mock_exam_view.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/practice_exam_view.dart';
import 'package:neuflo_learn/src/presentation/screens/home/widgets/test_navigate_card.dart';
import 'package:neuflo_learn/src/presentation/screens/tests/widgets/dailyTestCard.dart';

class Tests extends StatelessWidget {
  const Tests({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    final appCtrl = Get.find<AppStartupController>();

    return SizedBox(
      height: Constant.screenHeight,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 175,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF010029),
                    Color(0xFF003538),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Column(
                    children: [
                      Text(
                        "Tests",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Take a practice mock or custom test",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TestNavigateCard(
                              image: "assets/images/mock_test.png",
                              title: "Mock test",
                              description: "Simulated NEET test",
                              onTap: () {
                                Get.to(() => MockTestExamView());
                              },
                            ),
                            Gap(Constant.screenWidth *
                                (8 / Constant.figmaScreenWidth)),
                            TestNavigateCard(
                              image: "assets/images/custom_test.png",
                              title: "Custom test",
                              description: "Practise any topic",
                              onTap: () {
                                Get.to(() => CustomTestExamView());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 24),
                    child: Row(
                      children: [
                        Text(
                          "Daily tests",
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Color(0xff010029),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              height: 24,
                              width: 24,
                              child: Image.asset('assets/icons/physics.png'),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Physics',
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color(0xFF02013D),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                "${ctr.physicsattendedCount.value ?? '0'}/3",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Text("tests Done"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height:
                        100, // This is now the height for the ListView itself
                    child: ListView.separated(
                      padding: const EdgeInsets.only(right: 16),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemCount: 3,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 16 : 0),
                        child: DailyTestCard(
                          subName: 'Physics',
                          count: 20,
                          chapterName: index == 0
                              ? 'Physics is not about how the world looks, it\'s about how the world works.'
                              : index == 1
                                  ? 'The laws of physics are the rhythms of the universe.'
                                  : 'in Physics, the universe is under no obligation to make sense to you.',
                          onTap: () {
                            if (ctr.physics[index] == true) {
                              Fluttertoast.showToast(
                                  msg: 'Test already completed');
                              return;
                            }

                            Get.to(
                              () => PracticeTestExamView(
                                subjectName: 'Physics',
                                level: ctr.level[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 31,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              height: 24,
                              width: 24,
                              child: Image.asset('assets/icons/chemistry.png'),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              'Chemistry',
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color(0xFF02013D),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                "${ctr.chemattendedCount.value ?? '0'}/3",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text("tests Done")
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height:
                        100, // This is now the height for the ListView itself
                    child: ListView.separated(
                      padding: const EdgeInsets.only(right: 16),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemCount: 3,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 16 : 0),
                        child: DailyTestCard(
                          subName: 'Chemistry',
                          count: 20,
                          chapterName: index == 0
                              ? 'Chemistry is the science of matter and change.'
                              : index == 1
                                  ? 'In Chemistry, Chemical reactions rearrange atoms but don\'t destroy them.'
                                  : 'In Chemistry, water is not water. It is a chemical made of hydrogen and oxygen.',
                          onTap: () {
                            if (ctr.chemistry[index] == true) {
                              Fluttertoast.showToast(
                                  msg: 'Test already completed');
                              return;
                            }

                            Get.to(
                              () => PracticeTestExamView(
                                subjectName: 'Chemistry',
                                level: ctr.level[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 31,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              height: 24,
                              width: 24,
                              child: Image.asset('assets/icons/biology.png'),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              'Biology',
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color(0xFF02013D),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                "${ctr.bioattendedCount.value ?? '0'}/3",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text("tests Done")
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height:
                        100, // This is now the height for the ListView itself
                    child: ListView.separated(
                      padding: const EdgeInsets.only(right: 16),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemCount: 3,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 16 : 0),
                        child: DailyTestCard(
                          subName: 'Biology',
                          count: 20,
                          chapterName: index == 0
                              ? 'Biology is the science of life.'
                              : index == 1
                                  ? 'Biology is the analysis of complex interactions within and between living systems.'
                                  : 'Biology is the dynamic science of how life adapts, evolves, and persists.',
                          onTap: () {
                            if (ctr.biology[index] == true) {
                              Fluttertoast.showToast(
                                  msg: 'Test already completed');
                              return;
                            }

                            Get.to(
                              () => PracticeTestExamView(
                                subjectName: 'Biology',
                                level: ctr.level[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
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
