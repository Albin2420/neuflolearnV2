import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/widgets/app_btn/refreshButton.dart';

class FailureUi extends StatelessWidget {
  final Function onTapFunction;
  const FailureUi({super.key, required this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Image.asset('assets/images/anim.png'),
              SizedBox(height: 40),
              Text(
                "Sorry! Something went wrong...",
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Your internet might be unstable.",
                style: GoogleFonts.urbanist(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              Text(
                "Please try again.",
                style: GoogleFonts.urbanist(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              RefreshButton(
                btnName: "Refresh",
                onTapFunction: () => onTapFunction(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
