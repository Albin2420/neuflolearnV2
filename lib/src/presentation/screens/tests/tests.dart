import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/controller/home/home_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/Home/widgets/test_navigate_card.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/custom_exam_view.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/mock_exam_view.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/exam_view/widgets/practice_exam_view.dart';
import 'package:neuflo_learn/src/presentation/screens/home/widgets/test_card.dart';

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
                            const SizedBox(
                              width: 2,
                            ),
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
                    height: Constant.figmaScreenHeight *
                        (136 / Constant.figmaScreenHeight),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(right: 16, top: 16),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 8,
                        height: 8,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 16 : 0),
                        child: GestureDetector(
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
                          child: Testcard(
                            subjectName: 'Physics',
                            level: ctr.level[index],
                          ),
                        ),
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
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
                    height: Constant.figmaScreenHeight *
                        (136 / Constant.figmaScreenHeight),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(right: 16, top: 16),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 8,
                        height: 8,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 16 : 0),
                        child: GestureDetector(
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
                          child: Testcard(
                            subjectName: 'Chemistry',
                            level: ctr.level[index],
                          ),
                        ),
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
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
                    height: Constant.figmaScreenHeight *
                        (136 / Constant.figmaScreenHeight),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(right: 16, top: 16),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 8,
                        height: 8,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 16 : 0),
                        child: GestureDetector(
                          onTap: () {
                            if (ctr.biology[index]) {
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
                          child: Testcard(
                            subjectName: 'Biology',
                            level: ctr.level[index],
                          ),
                        ),
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Container(
                    // color: Colors.teal,
                    padding: const EdgeInsets.only(
                        top: 40, right: 16, left: 16, bottom: 40),
                    height: 80,
                    child: Divider(
                      color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          'Test history',
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Color(0xff010029)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xff02012A)
                                      .withValues(alpha: 0.5)))),
                      width: MediaQuery.of(context).size.width,
                      height: 54,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 2,
                              ),
                              Text("Search previous tests"),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            color: Color(0xff010029),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text(
                            "This week",
                            style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff010029)),
                            // color: Color(0xff010029),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text(
                            "This month",
                            style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 100,
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
