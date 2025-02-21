import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/controller/test%20history/test_history_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/All.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/biology_filtered.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/chemistry_filtered.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/custom_filtered.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/filterchip.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/mock_filtered.dart';
import 'package:neuflo_learn/src/presentation/screens/test%20history/widgets/physics_filtered.dart';

class TestHistory extends StatelessWidget {
  const TestHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(TestHistoryController());
    var filters = [
      All(),
      MockFiltered(),
      CustomFiltered(),
      BiologyFiltered(),
      ChemistryFiltered(),
      PhysicsFiltered(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffEDF1F2),
      appBar: AppBar(
        shadowColor: const Color(0x00000008),
        surfaceTintColor: Colors.white,
        elevation: 10,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Test history",
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF010029),
          ),
        ),
        flexibleSpace: Column(
          children: [
            const Spacer(),
            Container(
              height: 1,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Image.asset("assets/icons/left.png", scale: 3.5),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Filter Chip Section
            SizedBox(
              height: 33,
              child: Obx(() {
                return ListView.separated(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: ctr.filters.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        ctr.selectFilter(index);
                      },
                      child: Filterchip(
                        selectedIndex: index,
                        label: ctr.filters[index],
                      ),
                    );
                  },
                );
              }),
            ),
            //change based on index is required
            const SizedBox(height: 32),
            Obx(() {
              return filters[ctr.selectedFilter.value];
            }),
            SizedBox(
              height: 30,
            )
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Row(
            //     children: [
            //       Text(
            //         "THIS WEEK",
            //         style: GoogleFonts.urbanist(
            //           fontWeight: FontWeight.w500,
            //           fontSize: 12,
            //           color: const Color(0xff02012A).withOpacity(0.7),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 16),

            // SizedBox(
            //   height: 11,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 16),
            //   child: Row(
            //     children: [
            //       Text(
            //         "LAST WEEK",
            //         style: GoogleFonts.urbanist(
            //           fontWeight: FontWeight.w500,
            //           fontSize: 12,
            //           color: const Color(0xff02012A).withOpacity(0.7),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 11,
            // ),
            // Expanded(
            //   flex: 2,
            //   child: Container(
            //     color: Colors.yellow,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
