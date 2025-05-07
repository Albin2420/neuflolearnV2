import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:neuflo_learn/src/data/models/course.dart';
import 'package:neuflo_learn/src/presentation/controller/setup_account/setup_account_controller.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/app_btn.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final String title;
  final String? description;
  final IconData? iconImg;
  final Color color;
  final bool showBottomSheet;
  final String message;

  const CourseCard({
    super.key,
    required this.title,
    this.description,
    this.iconImg,
    required this.color,
    required this.showBottomSheet,
    required this.message,
    required this.course,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool buttonPressed = false;
  bool tapped = false;
  bool loading = false;
  List<String> physics = [
    'Physical World, Units and Measurements',
    'Motion in a Straight Line',
    'Motion in a Plane',
    'Laws of Motion',
    'Work, Energy and Power',
    'System of Particles and Rotational Motion',
    'Gravitation',
    'Mechanical Properties of Solids',
    'Mechanical Properties of Fluids',
    'Thermal Properties of Matter',
    'Thermodynamics',
    'Kinetic Theory',
    'Oscillations',
    'Waves',
    'Electric Charges and Fields',
    'Electrostatic Potential and Capacitance',
    'Current Electricity',
    'Moving Charges and Magnetism',
    'Magnetism and Matter',
    'Electromagnetic Induction',
    'Alternating Current',
    'Electromagnetic Waves',
    'Ray Optics and Optical',
    'Wave Optics',
    'Dual Nature of Radiation and Matter',
    'Atoms',
    'Nuclei',
    'Semiconductor Electronics: Materials, Devices and Simple Circuits',
  ];

  List<String> chemistry = [];
  List<String> biology = [];
  Color bordercolor = const Color(0x2002012A);

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<SetupAccountController>();
    return GestureDetector(
      onTap: () async {
        widget.showBottomSheet
            ? showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: const Color(0xFFEDF1F2),
                context: context,
                builder: (ctx) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Constant.screenWidth *
                          (16 / Constant.figmaScreenWidth),
                    ),
                    height: Constant.screenHeight - 45,
                    width: Constant.screenWidth,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color.fromRGBO(2, 1, 42, 0.1),
                          ),
                        ),
                        Gap(
                          Constant.screenHeight *
                              (12 / Constant.figmaScreenHeight),
                        ),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    widget.title,
                                    style: GoogleFonts.urbanist(
                                      fontSize: Constant.screenWidth *
                                          (16 / Constant.figmaScreenWidth),
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(1, 0, 41, 1),
                                    ),
                                  ),
                                  Text(
                                    "Tap to select strengths",
                                    style: GoogleFonts.urbanist(
                                      fontSize: Constant.screenWidth *
                                          (14 / Constant.figmaScreenWidth),
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(2, 1, 61, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(PhosphorIcons.x()),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Gap(
                              Constant.screenHeight *
                                  (28 / Constant.figmaScreenHeight),
                            ),
                            // ListView.builder(
                            //   scrollDirection: Axis.vertical,
                            //   physics: const ScrollPhysics(),
                            //   itemCount: physics.length - 20,
                            //   shrinkWrap: true,
                            //   itemBuilder: (context, index) {
                            //     return AddCourseCard(
                            //       text: physics[index],
                            //       value: buttonPressed,
                            //       onTap: () {
                            //         setState(() {
                            //           buttonPressed = !buttonPressed;
                            //         });
                            //       },
                            //     );
                            //   },
                            // )
                          ],
                        ),
                        const Spacer(),
                        AppBtn(
                          btnName: "Done",
                          onTapFunction: () => Navigator.pop(context),
                        ),
                        Gap(
                          Constant.screenHeight *
                              (16 / Constant.figmaScreenHeight),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const CircularProgressIndicator();
      },
      child: widget.showBottomSheet == false
          ? GestureDetector(
              onTap: () {
                setState(() {
                  // tapped == false ? tapped = true : tapped = false;

                  ctr.setCourse(course: widget.course);
                });
              },
              child: Container(
                padding: EdgeInsets.all(
                  Constant.screenWidth * (16 / Constant.figmaScreenWidth),
                ),
                // height: Constant.screenHeight * (85 / Constant.figmaScreenHeight),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: ctr.selectedCourseList.contains(widget.course)
                        ? const Color(0xff02012A)
                        : const Color(0x2002012A),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        widget.iconImg != null
                            ? Center(child: Icon(widget.iconImg))
                            : const SizedBox.shrink(),
                        Gap(
                          Constant.screenWidth *
                              (12 / Constant.figmaScreenWidth),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.title,
                                  style: GoogleFonts.urbanist(
                                    fontSize: Constant.screenHeight *
                                        (20 / Constant.figmaScreenHeight),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Gap(
                                  Constant.screenWidth *
                                      (8 / Constant.figmaScreenWidth),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Constant.screenWidth *
                                        (8 / Constant.figmaScreenWidth),
                                    vertical: Constant.screenHeight *
                                        (2 / Constant.figmaScreenHeight),
                                  ),
                                  height: Constant.screenHeight *
                                      (16 / Constant.figmaScreenHeight),
                                  decoration: ShapeDecoration(
                                    color: widget.color,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.message,
                                      style: TextStyle(
                                        color: const Color(0xFFF7FEFF),
                                        fontSize: Constant.screenHeight *
                                            (10 / Constant.figmaScreenHeight),
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: Constant.screenWidth - 180,
                              child: Text(
                                "${widget.description}",
                                style: GoogleFonts.urbanist(
                                  fontSize: Constant.screenHeight *
                                      (14 / Constant.figmaScreenHeight),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(
                      Constant.screenWidth * (24 / Constant.figmaScreenWidth),
                    ),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        scale: 3,
                        "assets/icons/right_arrow.png",
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(
                Constant.screenWidth * (16 / Constant.figmaScreenWidth),
              ),
              // height: Constant.screenHeight * (85 / Constant.figmaScreenHeight),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1,
                  color: tapped == true
                      ? const Color(0xff02012A)
                      : const Color(0x2002012A),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      widget.iconImg != null
                          ? Center(child: Icon(widget.iconImg))
                          : const SizedBox.shrink(),
                      Gap(
                        Constant.screenWidth * (12 / Constant.figmaScreenWidth),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.title,
                                style: GoogleFonts.urbanist(
                                  fontSize: Constant.screenHeight *
                                      (20 / Constant.figmaScreenHeight),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Gap(
                                Constant.screenWidth *
                                    (8 / Constant.figmaScreenWidth),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Constant.screenWidth *
                                      (8 / Constant.figmaScreenWidth),
                                  vertical: Constant.screenHeight *
                                      (2 / Constant.figmaScreenHeight),
                                ),
                                height: Constant.screenHeight *
                                    (16 / Constant.figmaScreenHeight),
                                decoration: ShapeDecoration(
                                  color: widget.color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.message,
                                    style: TextStyle(
                                      color: const Color(0xFFF7FEFF),
                                      fontSize: Constant.screenHeight *
                                          (10 / Constant.figmaScreenHeight),
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: Constant.screenWidth - 180,
                            child: Text(
                              widget.description!,
                              style: GoogleFonts.urbanist(
                                fontSize: Constant.screenHeight *
                                    (14 / Constant.figmaScreenHeight),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(
                    Constant.screenWidth * (24 / Constant.figmaScreenWidth),
                  ),
                ],
              ),
            ),
    );
  }
}
