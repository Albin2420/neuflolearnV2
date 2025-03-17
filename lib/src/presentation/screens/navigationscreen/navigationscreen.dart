import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/controller/navigation/navigation_controller.dart';
import 'package:neuflo_learn/src/presentation/screens/classes/classes_screen.dart';
import 'package:neuflo_learn/src/presentation/screens/exams/result/stat/test_stat.dart';
import 'package:neuflo_learn/src/presentation/screens/home/home.dart';
import 'package:neuflo_learn/src/presentation/screens/tests/tests.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainctr = Get.put(Navigationcontroller());
    final List<Widget> pages = [
      Home(),
      Tests(),
      // Classes(),
      TestStat(),
      Center(
        child: Text(
          "Coming soon.....",
          style: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF02012A),
          ),
        ),
      ),
    ];
    return Scaffold(
      backgroundColor: Color(0xFFEDF1F2),
      body: Obx(() {
        return pages[mainctr.currentIndex.value];
      }),
      bottomNavigationBar: Obx(
        () {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            enableFeedback: true,
            currentIndex: mainctr.currentIndex.value,
            onTap: (index) {
              mainctr.changeIndex(index);
            },
            unselectedItemColor: const Color(0xFF02012A),
            unselectedLabelStyle: GoogleFonts.urbanist(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            selectedLabelStyle: GoogleFonts.urbanist(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
            selectedItemColor: const Color(0xFF02012A),
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  PhosphorIcons.house(mainctr.currentIndex.value == 0
                      ? PhosphorIconsStyle.fill
                      : PhosphorIconsStyle.regular),
                ),
                label: "HOME",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  PhosphorIcons.question(mainctr.currentIndex.value == 1
                      ? PhosphorIconsStyle.fill
                      : PhosphorIconsStyle.regular),
                ),
                label: "TESTS",
              ),
              // BottomNavigationBarItem(
              //   icon: SizedBox(
              //     height: 26,
              //     width: 20,
              //     child: mainctr.currentIndex.value == 2
              //         ? Image.asset('assets/icons/playerselected.png')
              //         : Image.asset('assets/icons/playernotselected.png'),
              //   ),
              //   label: "CLASSES",
              // ),
              BottomNavigationBarItem(
                icon: Icon(
                  PhosphorIcons.chartBar(mainctr.currentIndex.value == 2
                      ? PhosphorIconsStyle.fill
                      : PhosphorIconsStyle.regular),
                ),
                label: "STATS",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  PhosphorIcons.chatTeardropText(mainctr.currentIndex.value == 3
                      ? PhosphorIconsStyle.fill
                      : PhosphorIconsStyle.regular),
                ),
                label: "ASK AI",
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    log("FCM Token: $token");
  }
}
