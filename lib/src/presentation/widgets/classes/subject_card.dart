import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';

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
    ClassesController classesController = Get.find<ClassesController>();
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
              height: 24,
              width: 24,
              child: Image.asset(
                subName == "Physics"
                    ? 'assets/icons/physics.png'
                    : subName == "Chemistry"
                        ? 'assets/icons/chemistry.png'
                        : 'assets/icons/biology.png',
                // width: 24,
                // height: 24,
              ),
            ),
            const SizedBox(width: 5),

            // Subject Name
            Expanded(
              child: Text(
                subName,
                style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: AppColors.subjectTextColor,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Progress
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
                Obx(
                  () => Text(
                    subName == 'Physics'
                        ? classesController.physics.length.toString()
                        : subName == 'Chemistry'
                            ? classesController.chemistry.length.toString()
                            : subName == 'Biology'
                                ? classesController.biology.length.toString()
                                : '0',
                    style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.completedTextArrowColor),
                  ),
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
