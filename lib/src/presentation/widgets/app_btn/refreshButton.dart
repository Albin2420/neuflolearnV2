import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RefreshButton extends StatelessWidget {
  final String btnName;
  final Widget? routePage;
  final Function onTapFunction;
  final IconData? iconImg;
  final List<Color>? colors;

  const RefreshButton({
    super.key,
    required this.btnName,
    this.routePage,
    required this.onTapFunction,
    this.iconImg,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapFunction(),
      child: Material(
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors ?? [Color(0xFF010029), Color(0xFF010048)],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: iconImg != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Text(
                btnName,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (iconImg != null) ...[
                SizedBox(width: 4),
                Icon(iconImg, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
