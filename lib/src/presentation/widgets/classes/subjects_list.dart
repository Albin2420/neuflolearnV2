import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';
import 'package:neuflo_learn/src/presentation/widgets/classes/subject_card.dart';

class SubjectsList extends StatelessWidget {
  const SubjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    ClassesController classesController = Get.find<ClassesController>();
    return Obx(() {
      return SubjectCard(
        subName: "jhgh",
        currentcount: 2,
        totalCount: 6,
        onTap: () {},
      );
    });
  }
}
