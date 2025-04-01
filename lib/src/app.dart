import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/screens/splash/splash.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/subject_card.dart';

class NeufloLearn extends StatelessWidget {
  const NeufloLearn({super.key});

  @override
  Widget build(BuildContext context) {
    Constant.init(context: context);
    return GetMaterialApp(
      // showPerformanceOverlay: true,
      title: 'Neuflo',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Splash(),
    );
  }
}

class name extends StatelessWidget {
  const name({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Header(),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 1,
            right: 1,
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, bottom: 10),
                    child: Text(
                      "Live Class",
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                    child: LiveSection(
                      title: "electromagnetism",
                      color: Colors.white,
                      time: '23012025T10:20:00',
                      onTapCallback: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Classes",
                                style: GoogleFonts.urbanist(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                "Brush up your coursework",
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: AppColors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Subjects",
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: SubjectCard(
                          subName: "Physics",
                          currentcount: 2,
                          totalCount: 10,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(height: 13),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: SubjectCard(
                          subName: "Chemistry",
                          currentcount: 2,
                          totalCount: 4,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(height: 13),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: SubjectCard(
                          subName: "Biology",
                          currentcount: 2,
                          totalCount: 5,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final int currentcount;
  final int totalCount;
  final String subName;
  final VoidCallback onTap; // Callback function

  const SubjectCard({
    super.key,
    required this.subName,
    required this.currentcount,
    required this.totalCount,
    required this.onTap, // Required callback function
  });

  @override
  Widget build(BuildContext context) {
    // ClassesController classesController = Get.find<ClassesController>();
    return GestureDetector(
      onTap: onTap, // Calls the function when tapped
      child: Container(
        height: 74,
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Subject Icon
            SizedBox(
              height: 20,
              width: 20,
              child: Image.asset(
                subName == "Physics"
                    ? 'assets/icons/physics.png'
                    : subName == "Chemistry"
                        ? 'assets/icons/chemistry.png'
                        : 'assets/icons/biology.png',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                subName,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: AppColors.timeTextColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Text(
                  "$currentcount",
                  style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.completedTextArrowColor),
                ),
                Text(
                  '/',
                  style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.completedTextArrowColor),
                ),
                const SizedBox(width: 5),
                Text(
                  "chapters completed",
                  style: GoogleFonts.urbanist(
                      fontSize: 14, color: AppColors.timeTextColor),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 45,
                  width: 15,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.completedTextArrowColor,
                    size: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)),
        gradient: RadialGradient(
          center: Alignment.bottomRight,
          radius: 1.0,
          colors: [
            AppColors.gradientEnd,
            AppColors.statusBarColor,
          ],
          stops: [0.5, 0.8],
        ),
      ),
    );
  }
}

// import 'dart:developer';

class LiveSection extends StatelessWidget {
  final String title;
  final Color color;
  final String time; // The time in '2025-03-28T22:00:00' format
  final VoidCallback onTapCallback;

  const LiveSection({
    super.key,
    required this.title,
    required this.color,
    required this.time,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the time string into a DateTime object
    DateTime parsedTime = DateTime.parse(time);

    // Format the time in 12-hour format with AM/PM
    // String formattedTime = DateFormat.jm().format(parsedTime);

    // For example: '10:00 PM'

    // ClassesController classesController = Get.find<ClassesController>();

    return GestureDetector(
      onTap: () => onTapCallback(),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.urbanist(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 18,
                            width: 18,
                            child: Image.asset(
                              'assets/images/union.png',
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "", // Display the formatted time
                            style: GoogleFonts.urbanist(
                                fontSize: 16, color: AppColors.timeTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(30)),
                child: Image.asset(
                  'assets/images/arrow_right.png',
                  height: 20,
                  width: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
