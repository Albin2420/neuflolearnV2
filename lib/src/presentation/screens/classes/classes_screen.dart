import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/currently_playing.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/header.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/subject_card.dart';

import '../../../core/config/theme/colors.dart';
import '../../controller/classes/classes_controller.dart';

class Classes extends StatelessWidget {
  const Classes({super.key});

  @override
  Widget build(BuildContext context) {
    ClassesController classesController = Get.put(ClassesController());

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.statusBarColor,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Header(),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        Text(
                          "Subjects",
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 12),
                        SubjectCard(
                          subName: "Physics",
                          currentcount: 2,
                          totalCount: classesController.physics.length,
                          onTap: () {
                            classesController.onSubjectSelected(subject: 1);
                          },
                        ),
                        SizedBox(height: 13),
                        SubjectCard(
                          subName: "Chemistry",
                          currentcount: 2,
                          totalCount: classesController.chemistry.length,
                          onTap: () {
                            classesController.onSubjectSelected(subject: 2);
                          },
                        ),
                        SizedBox(height: 13),
                        SubjectCard(
                          subName: "Biology",
                          currentcount: 2,
                          totalCount: classesController.biology.length,
                          onTap: () {
                            classesController.onSubjectSelected(subject: 3);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Ensure Positioned is placed directly inside Stack
          Positioned(
            top: 190,
            left: 20,
            right: 20,
            child: CurrentlyPlaying(
              seconds: 365,
              title: 'Electromagnetism',
              am_pm: 'PM',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
