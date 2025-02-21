import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String name;
  final String email;
  final String imagePath;
  final String studentType;

  const ProfileInfoWidget({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
    required this.studentType,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // double containerWidth = screenWidth * 0.9;

    double containerWidth = screenWidth * 0.9;
    double containerHeight = screenHeight * 0.135;

    log('NAME ::: $name');

    log('EMAIL  ::: $email');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: containerHeight,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 5,
              color: Colors.black,
              shape: const CircleBorder(),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: imagePath != null
                    ? NetworkImage(imagePath)
                    : const NetworkImage(
                        'https://imgs.search.brave.com/_QS-C_ZdFRoEEb83lITyO3dY1Y6syO6ywUb65b2ZRcQ/rs:fit:500:0:0/g:ce/aHR0cHM6Ly93d3cu/dzNzY2hvb2xzLmNv/bS9ob3d0by9pbWdf/YXZhdGFyLnBuZw'),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Flexible(
                    child: Text(
                      email,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      studentType,
                      style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
