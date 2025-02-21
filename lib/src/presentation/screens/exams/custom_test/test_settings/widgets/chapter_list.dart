import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/presentation/controller/custom_test/custom_test_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/custom_test/widgets/custom_selection_card.dart';

class ChapterList extends StatelessWidget {
  const ChapterList({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<CustomTestController>();
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Obx(
        () => ctr.chapterState.value.onState(
          onInitial: () => SizedBox(),
          success: (data) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, index) {
                bool isSelected = ctr.selectedChapters.contains(data[index]);
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: CourseSelectionCard(
                    isSelected: isSelected,
                    chapter: data[index],
                    onChapterSelected: (chapter) {
                      ctr.addChapter(chapter: chapter);
                      if (ctr.selectedSubjectName.value == 'Physics') {
                        ctr.addPhysicsChapters(chapter.chapterId);
                      } else if (ctr.selectedSubjectName.value == 'Chemistry') {
                        ctr.addChemistryChapters(chapter.chapterId);
                      } else {
                        ctr.addBiologyChapters(chapter.chapterId);
                      }
                    },
                  ),
                );
              },
            );
          },
          onFailed: (error) {
            return Text('Chapters failed to load');
          },
          onLoading: () {
            return Center(
              child: Transform.scale(
                scale: 0.5,
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
