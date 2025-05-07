import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

class AccountSetupFailed extends StatelessWidget {
  String userName;
  AccountSetupFailed({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kScaffoldBg2,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/icons/logo.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Text(
                        'Neuflo',
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w400,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        "Learn",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF6C00),
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Hi $userName, \naccount setup completed, Waiting for Confirmation Please contact for further updates.",
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF010029),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Image.asset('assets/images/confirmation.png'),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: RichText(
                  text: TextSpan(
                    text: 'neuflo  ',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '|  ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '+91 9600000000',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: '  |  ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'abc@gmail.com',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
