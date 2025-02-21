import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Nextstep extends StatelessWidget {
  final VoidCallback onFinishDailyTests;
  final VoidCallback onSetTestReminders;

  const Nextstep({
    super.key,
    required this.onFinishDailyTests,
    required this.onSetTestReminders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 5.8,
            spreadRadius: 0,
          ),
        ],
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Color(0xff0000001a).withValues(alpha: 0.1),
        ),
      ),
      padding: EdgeInsets.only(left: 16, top: 24, right: 16),
      height: 332,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Next steps",
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xff01002980).withOpacity(0.5)),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: onFinishDailyTests, // Use the callback here
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF5FAFF),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.only(
                left: 16,
              ),
              height: 111,
              child: Row(
                children: [
                  SizedBox(
                    height: 56,
                    width: 56,
                    child: Image.asset(
                      "assets/images/calendar.png",
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 24, bottom: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Finish daily tests",
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Finish your daily tests, building your learning streak!",
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: Color(0xff010029),
                      size: 28,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: onSetTestReminders, // Use the callback here
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffFFF5ED),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.only(
                left: 16,
              ),
              height: 111,
              child: Row(
                children: [
                  SizedBox(
                    height: 56,
                    width: 56,
                    child: Image.asset(
                      "assets/images/notification.png",
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 24, bottom: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Set test reminders",
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Never miss an opportunity to learn.",
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: Color(0xff010029),
                      size: 28,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
