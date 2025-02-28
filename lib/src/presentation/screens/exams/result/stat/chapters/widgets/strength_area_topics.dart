import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

class StrengthAreaTopics extends StatelessWidget {
  final String toPic;
  final double cRCpercentage;
  const StrengthAreaTopics(
      {super.key, required this.toPic, required this.cRCpercentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  toPic,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                width: 13,
              ),
              Text(
                "${(cRCpercentage).toInt()}% correct",
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.kgreen,
                ),
              )
            ],
          ),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(48),
            backgroundColor: Color(0xff18AC00).withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color?>(Color(0xff18AC00)),
            value: cRCpercentage / 100,
          )
        ],
      ),
    );
  }
}
