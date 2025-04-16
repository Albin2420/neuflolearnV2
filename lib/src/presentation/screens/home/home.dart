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
import 'package:neuflo_learn/src/presentation/screens/home/widgets/streak_widget.dart';
import 'package:neuflo_learn/src/presentation/screens/home/widgets/test_card.dart';
import 'package:neuflo_learn/src/presentation/screens/profile/profile_page.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(HomeController());
    final appCtrl = Get.find<AppStartupController>();

    return SizedBox(
      height: Constant.screenHeight,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height:
                  Constant.screenHeight * (284 / Constant.figmaScreenHeight),
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
                  Padding(
                    padding: EdgeInsets.all(Constant.screenWidth *
                        (16 / Constant.figmaScreenWidth)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Welcome, ",
                                        style: GoogleFonts.urbanist(
                                          fontSize: Constant.screenHeight *
                                              (20 / Constant.figmaScreenHeight),
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFFF3FAFF),
                                        ),
                                      ),
                                      Expanded(
                                        child: Obx(() => Text(
                                              '${Get.find<AppStartupController>().appUser.value?.name}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.urbanist(
                                                fontSize: Constant
                                                        .screenHeight *
                                                    (20 /
                                                        Constant
                                                            .figmaScreenHeight),
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xFFF3FAFF),
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "Let’s begin your learnings for today",
                                    style: GoogleFonts.urbanist(
                                      fontSize: Constant.screenHeight *
                                          (14 / Constant.figmaScreenHeight),
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFF3FAFF),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => ProfilePage());
                                },
                                child: Obx(() {
                                  // Fetch imageUrl safely
                                  String? imageUrl =
                                      Get.find<AppStartupController>()
                                          .appUser
                                          .value
                                          ?.imageUrl;

                                  bool isImageUrlValid =
                                      imageUrl != null && imageUrl.isNotEmpty;

                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // CircleAvatar with the image
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: CircleAvatar(
                                          radius: Constant.screenHeight *
                                              (20 / Constant.figmaScreenHeight),
                                          backgroundImage: isImageUrlValid
                                              ? NetworkImage(imageUrl)
                                              : null, // Only assign NetworkImage if valid
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                      // Fallback placeholder for error case
                                      if (!isImageUrlValid)
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: CircleAvatar(
                                            radius: Constant.screenHeight *
                                                (20 /
                                                    Constant.figmaScreenHeight),
                                            backgroundColor: Colors
                                                .grey, // Placeholder background color
                                            child: PhosphorIcon(
                                              PhosphorIcons
                                                  .user(), // Fallback icon
                                              color: Colors.white, // Icon color
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                }),
                              ),
                            )
                          ],
                        ),
                        Gap(
                          Constant.screenHeight *
                              (40 / Constant.figmaScreenHeight),
                        ),
                        Text(
                          "Daily tests",
                          style: GoogleFonts.urbanist(
                            fontSize: Constant.screenHeight *
                                (24 / Constant.figmaScreenHeight),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF3FAFF),
                          ),
                        ),
                        Gap(
                          Constant.screenHeight *
                              (24 / Constant.figmaScreenHeight),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Container(
                            padding: EdgeInsets.all(
                              Constant.screenWidth *
                                  (16 / Constant.figmaScreenWidth),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Daily streak",
                                  style: GoogleFonts.urbanist(
                                    fontSize: Constant.screenHeight *
                                        (16 / Constant.figmaScreenHeight),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Gap(
                                  Constant.screenHeight *
                                      (16 / Constant.figmaScreenHeight),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: StreakWidget(),
                                ),
                                Gap(
                                  Constant.screenHeight *
                                      (32 / Constant.figmaScreenHeight),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Today's goal",
                                      style: GoogleFonts.urbanist(
                                        fontSize: Constant.screenHeight *
                                            (16 / Constant.figmaScreenHeight),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF000000),
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        "${ctr.totalTestDonePerDay}/9 test done",
                                        style: GoogleFonts.urbanist(
                                          fontSize: Constant.screenHeight *
                                              (14 / Constant.figmaScreenHeight),
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF010029),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(
                                  Constant.screenHeight *
                                      (8 / Constant.figmaScreenHeight),
                                ),
                                Obx(() => ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        minHeight: 8,
                                        value: int.parse(
                                                '${ctr.totalTestDonePerDay}') /
                                            9,
                                        color: Color(0xFF010029),
                                        backgroundColor: Color(0xFFD9D9D9),
                                      ),
                                    )),
                              ],
                            ),
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
                                "${ctr.physicsattendedCount.value}/3",
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
                            tile: index == 0
                                ? "Physics is like a puzzle. Start with the small pieces, and you'll see the bigger picture unfold"
                                : index == 1
                                    ? "The more you understand the laws of nature, the more you'll realize how much beauty lies in the universe's simplicity"
                                    : "Physics is the language of the cosmos, and every equation is a conversation with the universe waiting to be understood",
                            color: index == 0
                                ? Color(0xff18AC00)
                                : index == 1
                                    ? Color(0xffFF6C00)
                                    : Color(0xff02012A),
                            count: ctr.now.day,
                            subjectName: 'Physics',
                            level: index == 0
                                ? 'Beginner'
                                : index == 1
                                    ? 'Intermediate'
                                    : 'Advanced',
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
                            tile: index == 0
                                ? "Chemistry is the study of everything around us, from the air we breathe to the food we eat. Every molecule has a story"
                                : index == 1
                                    ? "In chemistry, understanding the bonds between atoms helps us unlock the mysteries of matter and change"
                                    : "Chemistry is the art of transformation, where atoms dance, rearrange, and create the world as we know it, governed by the elegant laws of nature",
                            color: index == 0
                                ? Color(0xffFF6C00)
                                : index == 1
                                    ? Color(0xff18AC00)
                                    : Color(0xff02012A),
                            count: ctr.now.day,
                            subjectName: 'Chemistry',
                            level: index == 0
                                ? 'Beginner'
                                : index == 1
                                    ? 'Intermediate'
                                    : 'Advanced',
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
                          child: Testcard(
                            tile: index == 0
                                ? "Biology is the study of life, from the tiniest cell to the vastness of ecosystems. Every living thing has a story to tell"
                                : index == 1
                                    ? "In biology, every organism is a masterpiece of evolution, shaped by the forces of nature and time"
                                    : "Biology is the intricate dance of life at every scale, where molecular processes, genetic codes, and ecological systems intertwine to create the complexity of living organisms",
                            color: index == 0
                                ? Color(0xff02012A)
                                : index == 1
                                    ? Color(0xffFF6C00)
                                    : Color(0xff18AC00),
                            count: ctr.now.day,
                            subjectName: 'Biology',
                            level: index == 0
                                ? 'Beginner'
                                : index == 1
                                    ? 'Intermediate'
                                    : 'Advanced',
                          ),
                        ),
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // color: Colors.teal,
                    padding: const EdgeInsets.only(
                        top: 40, right: 16, left: 16, bottom: 40),
                    height: 80,
                    child: Divider(
                      color: const Color(0xFF000000).withOpacity(0.5),
                    ),
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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => MockTestExamView());
                    },
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.all(16),
                      height: 126,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                          color: const Color(0xFF010029),
                          borderRadius: BorderRadius.circular(16)),
                      child: Stack(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                width: constraints.maxWidth,
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "NEET mock test",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    Text(
                                      "Test out your skills in a real",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    Text(
                                      "exam simulation",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: -18,
                            right: -5,
                            child: Image.asset(
                              "assets/images/neet_mock_test_person.png",
                              width: 172,
                              height: 172,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 43,
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
