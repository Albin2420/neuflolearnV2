// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
// import 'package:neuflo_learn/src/presentation/screens/account_setup/widgets/target_card.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';

// class TargetArea extends StatefulWidget {
//   const TargetArea({super.key});

//   @override
//   State<TargetArea> createState() => _TargetAreaState();
// }

// class _TargetAreaState extends State<TargetArea> {
//   String responseData = '';

//   @override
//   void initState() {
//     super.initState();
//     // fetchChapterNames(1);
//     // fetchChapterNames(2);
//     // fetchChapterNames(3);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Text(
//             'What are your weaknesses and strengths?',
//             style: GoogleFonts.urbanist(
//               fontSize:
//                   Constant.screenHeight * (24 / Constant.figmaScreenHeight),
//               fontWeight: FontWeight.w600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           Text(
//             'This will help us curate the best learning experience for you.',
//             style: GoogleFonts.urbanist(
//               fontSize:
//                   Constant.screenHeight * (16 / Constant.figmaScreenHeight),
//               fontWeight: FontWeight.w400,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           Gap(Constant.screenHeight * (32 / Constant.figmaScreenHeight)),
//           SizedBox(
//             height: Constant.screenHeight * (280 / Constant.figmaScreenHeight),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: Constant.screenWidth *
//                           (8 / Constant.figmaScreenWidth),
//                       vertical: Constant.screenHeight *
//                           (16 / Constant.figmaScreenHeight)),
//                   width:
//                       Constant.screenWidth * (33 / Constant.figmaScreenWidth),
//                   decoration: BoxDecoration(
//                       color: const Color(0xFF18AC00),
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Icon(
//                         PhosphorIcons.thumbsUp(PhosphorIconsStyle.fill),
//                         color: Colors.white,
//                       ),
//                       const Spacer(),
//                       RotatedBox(
//                         quarterTurns: 3,
//                         child: Text(
//                           'Strengths',
//                           style: GoogleFonts.urbanist(
//                             color: Colors.white,
//                             fontSize: Constant.screenHeight *
//                                 (14 / Constant.figmaScreenHeight),
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Gap(Constant.screenHeight * (12 / Constant.figmaScreenHeight)),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       TargetCard(
//                         title: 'Physics',
//                         color: const Color(0xFF18AC00),
//                         description: 'Tap To Select topics',
//                         iconImg: PhosphorIcons.atom(),
//                         showBottomSheet: true,
//                         chapterNames: [],
//                         type: 'Strength',
//                       ),
//                       Gap(Constant.screenHeight *
//                           (12 / Constant.figmaScreenHeight)),
//                       TargetCard(
//                         title: 'Chemistry',
//                         color: const Color(0xFF18AC00),
//                         description: 'Tap To Select topics',
//                         iconImg: PhosphorIcons.flask(),
//                         showBottomSheet: true,
//                         chapterNames: [],
//                         type: 'Strength',
//                       ),
//                       Gap(Constant.screenHeight *
//                           (12 / Constant.figmaScreenHeight)),
//                       TargetCard(
//                         color: const Color(0xFF18AC00),
//                         title: 'Biology',
//                         description: 'Tap To Select topics',
//                         iconImg: PhosphorIcons.stethoscope(),
//                         showBottomSheet: true,
//                         chapterNames: [],
//                         type: 'Strength',
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Gap(Constant.screenHeight * (40 / Constant.figmaScreenHeight)),
//           SizedBox(
//             height: Constant.screenHeight * (280 / Constant.figmaScreenHeight),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: Constant.screenWidth *
//                           (8 / Constant.figmaScreenWidth),
//                       vertical: Constant.screenHeight *
//                           (16 / Constant.figmaScreenHeight)),
//                   width:
//                       Constant.screenWidth * (33 / Constant.figmaScreenWidth),
//                   decoration: BoxDecoration(
//                       color: const Color(0xFFD84040),
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Column(
//                     children: [
//                       Icon(
//                         PhosphorIcons.thumbsDown(PhosphorIconsStyle.fill),
//                         color: Colors.white,
//                       ),
//                       const Spacer(),
//                       RotatedBox(
//                         quarterTurns: 3,
//                         child: Text(
//                           'Weakness',
//                           style: GoogleFonts.urbanist(
//                             color: Colors.white,
//                             fontSize: Constant.screenHeight *
//                                 (14 / Constant.figmaScreenHeight),
//                             fontWeight: FontWeight.w700,
//                             // Add other text styles as needed
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Gap(Constant.screenHeight * (12 / Constant.figmaScreenHeight)),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       TargetCard(
//                         title: 'Physics',
//                         color: const Color(0xFFD84040),
//                         description: 'Tap To Select topics',
//                         iconImg: PhosphorIcons.atom(),
//                         showBottomSheet: true,
//                         chapterNames: [],
//                         type: 'Weakness',
//                       ),
//                       Gap(Constant.screenHeight *
//                           (12 / Constant.figmaScreenHeight)),
//                       TargetCard(
//                         color: const Color(0xFFD84040),
//                         title: 'Chemistry',
//                         description: 'Tap To Select topics',
//                         iconImg: PhosphorIcons.flask(),
//                         showBottomSheet: true,
//                         chapterNames: [],
//                         type: 'Weakness',
//                       ),
//                       Gap(Constant.screenHeight *
//                           (12 / Constant.figmaScreenHeight)),
//                       TargetCard(
//                         color: const Color(0xFFD84040),
//                         title: 'Biology',
//                         description: 'Tap To Select topics',
//                         iconImg: PhosphorIcons.stethoscope(),
//                         showBottomSheet: true,
//                         chapterNames: [],
//                         type: 'Weakness',
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Gap(Constant.screenHeight * (16 / Constant.figmaScreenHeight))
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/presentation/controller/setup_account/setup_account_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/account_setup/widgets/target_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TargetArea extends StatelessWidget {
  const TargetArea({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<SetupAccountController>();

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'What are your weaknesses and strengths?',
            style: GoogleFonts.urbanist(
              fontSize:
                  Constant.screenHeight * (24 / Constant.figmaScreenHeight),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'This will help us curate the best learning\n experience for you.',
            style: GoogleFonts.urbanist(
              fontSize:
                  Constant.screenHeight * (16 / Constant.figmaScreenHeight),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(Constant.screenHeight * (32 / Constant.figmaScreenHeight)),
          SizedBox(
            height:
                Constant.screenHeight * (280 / Constant.figmaScreenHeight) + 15,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constant.screenWidth *
                          (8 / Constant.figmaScreenWidth),
                      vertical: Constant.screenHeight *
                          (16 / Constant.figmaScreenHeight)),
                  width:
                      Constant.screenWidth * (33 / Constant.figmaScreenWidth),
                  decoration: BoxDecoration(
                      color: AppColors.kgreen,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIcons.thumbsUp(PhosphorIconsStyle.fill),
                        color: Colors.white,
                        size: 14,
                      ),
                      const Spacer(),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Strengths',
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: Constant.screenHeight *
                                (14 / Constant.figmaScreenHeight),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(Constant.screenHeight * (12 / Constant.figmaScreenHeight)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GetBuilder<SetupAccountController>(
                        builder: (controller) {
                          return TargetCard(
                            title: 'Physics',
                            color: AppColors.kgreen,
                            description: 'Tap To Select topics',
                            iconImg: PhosphorIcons.atom(),
                            showBottomSheet: true,
                            type: 'Strength',
                            selectedChapterCount:
                                ctr.strengthPhysicsSelected.value,
                          );
                        },
                      ),
                      Gap(Constant.screenHeight *
                          (12 / Constant.figmaScreenHeight)),
                      GetBuilder<SetupAccountController>(
                        builder: (controller) {
                          return TargetCard(
                            title: 'Chemistry',
                            color: AppColors.kgreen,
                            description: 'Tap To Select topics',
                            iconImg: PhosphorIcons.flask(),
                            showBottomSheet: true,
                            type: 'Strength',
                            selectedChapterCount:
                                ctr.strengthChemistrySelected.value,
                          );
                        },
                      ),
                      Gap(Constant.screenHeight *
                          (12 / Constant.figmaScreenHeight)),
                      GetBuilder<SetupAccountController>(
                        builder: (controller) {
                          return TargetCard(
                            color: AppColors.kgreen,
                            title: 'Biology',
                            description: 'Tap To Select topics',
                            iconImg: PhosphorIcons.stethoscope(),
                            showBottomSheet: true,
                            type: 'Strength',
                            selectedChapterCount:
                                ctr.strengthBiolgySelected.value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(Constant.screenHeight * (40 / Constant.figmaScreenHeight)),
          SizedBox(
            height:
                Constant.screenHeight * (280 / Constant.figmaScreenHeight) + 15,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constant.screenWidth *
                          (8 / Constant.figmaScreenWidth),
                      vertical: Constant.screenHeight *
                          (16 / Constant.figmaScreenHeight)),
                  width:
                      Constant.screenWidth * (33 / Constant.figmaScreenWidth),
                  decoration: BoxDecoration(
                      color: AppColors.kred,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Icon(
                        PhosphorIcons.thumbsDown(PhosphorIconsStyle.fill),
                        color: Colors.white,
                        size: 14,
                      ),
                      const Spacer(),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Weakness',
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: Constant.screenHeight *
                                (14 / Constant.figmaScreenHeight),
                            fontWeight: FontWeight.w700,
                            // Add other text styles as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(Constant.screenHeight * (12 / Constant.figmaScreenHeight)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GetBuilder<SetupAccountController>(
                        builder: (controller) {
                          return TargetCard(
                            title: 'Physics',
                            color: AppColors.kred,
                            description: 'Tap To Select topics',
                            iconImg: PhosphorIcons.atom(),
                            showBottomSheet: true,
                            type: 'Weakness',
                            selectedChapterCount:
                                ctr.weaknessPhysicsSelected.value,
                          );
                        },
                      ),
                      Gap(Constant.screenHeight *
                          (12 / Constant.figmaScreenHeight)),
                      GetBuilder<SetupAccountController>(
                        builder: (controller) {
                          return TargetCard(
                            color: const Color(0xFFD84040),
                            title: 'Chemistry',
                            description: 'Tap To Select topics',
                            iconImg: PhosphorIcons.flask(),
                            showBottomSheet: true,
                            type: 'Weakness',
                            selectedChapterCount:
                                ctr.weaknessChemistrySelected.value,
                          );
                        },
                      ),
                      Gap(Constant.screenHeight *
                          (12 / Constant.figmaScreenHeight)),
                      GetBuilder<SetupAccountController>(
                        builder: (controller) {
                          return TargetCard(
                            color: AppColors.kred,
                            title: 'Biology',
                            description: 'Tap To Select topics',
                            iconImg: PhosphorIcons.stethoscope(),
                            showBottomSheet: true,
                            type: 'Weakness',
                            selectedChapterCount:
                                ctr.weaknessBiologySelected.value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(Constant.screenHeight * (16 / Constant.figmaScreenHeight))
        ],
      ),
    );
  }
}
