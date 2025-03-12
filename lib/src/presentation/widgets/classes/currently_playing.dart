import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';
import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';

class CurrentlyPlaying extends StatelessWidget {
  final String title;
  final double seconds;
  final String am_pm;
  final Color color;
  const CurrentlyPlaying(
      {super.key,
      required this.title,
      required this.seconds,
      required this.am_pm,
      required this.color});

  @override
  Widget build(BuildContext context) {
    ClassesController classesController = Get.find<ClassesController>();
    return GestureDetector(
      onTap: () {
        log("Go to live class");
      },
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 90,
              width: 270,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.urbanist(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
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
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${classesController.formatDuration(seconds.toInt())} pm",
                          style: GoogleFonts.urbanist(
                              fontSize: 16, color: AppColors.timeTextColor),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
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
            // Container(
            //   height: 60,
            //   width: 60,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(25),
            //   ),
            //   child: Container(
            //       height: 50,
            //       width: 50,
            //       decoration: BoxDecoration(
            //           color: AppColors.orange,
            //           borderRadius: BorderRadius.circular(30)),
            //       child: Image.asset('assets/images/arrow_right.png')),
            // ),
          ],
        ),
      ),
    );
  }
}
