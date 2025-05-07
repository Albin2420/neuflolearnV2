import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

class ProblemAreaTopics extends StatelessWidget {
  final String toPic;
  final double inCRCpercentage;
  const ProblemAreaTopics({
    super.key,
    required this.toPic,
    required this.inCRCpercentage,
  });

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
              SizedBox(width: 13),
              Text(
                "${(inCRCpercentage).toInt()}% incorrect",
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.kred,
                ),
              ),
            ],
          ),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(48),
            backgroundColor: Color(0xffD84040).withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color?>(Color(0xffD84040)),
            value: inCRCpercentage / 100,
          ),
        ],
      ),
    );
  }
}
