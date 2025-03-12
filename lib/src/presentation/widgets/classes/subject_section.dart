// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';

// import 'subject_card.dart';

// class SubjectSection extends StatelessWidget {
//   const SubjectSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     ClassesController classesController = Get.find<ClassesController>();
//     return Padding(
//       padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
//       child: Positioned(
//         left: 16,
//         right: 16,
//         top: 270,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 12,
//             ),
//             Text(
//               "Subjects",
//               style: GoogleFonts.urbanist(
//                   fontWeight: FontWeight.bold, fontSize: 24),
//             ),
//             SizedBox(
//               height: 12,
//             ),
//             SubjectCard(
//               subName: "Physics",
//               currentcount: 2,
//               totalCount: classesController.physics.length,
//               onTap: () {
//                 classesController.onSubjectSelected(subject: 1);
//               },
//             ),
//             SizedBox(
//               height: 13,
//             ),
//             SubjectCard(
//               subName: "Chemistry",
//               currentcount: 2,
//               totalCount: classesController.chemistry.length,
//               onTap: () {
//                 classesController.onSubjectSelected(subject: 2);
//               },
//             ),
//             SizedBox(
//               height: 13,
//             ),
//             SubjectCard(
//               subName: "Biology",
//               currentcount: 2,
//               totalCount: classesController.biology.length,
//               onTap: () {
//                 classesController.onSubjectSelected(subject: 3);
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
