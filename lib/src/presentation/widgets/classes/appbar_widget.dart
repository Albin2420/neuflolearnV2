import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String subject;

  const CustomAppBar({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            height: 100,
            width: 30,
            color: Colors.white,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Image.asset('assets/images/vector.png'),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset(subject == 'Physics'
                      ? "assets/icons/physics.png"
                      : subject == 'Chemistry'
                          ? 'assets/icons/chemistry.png'
                          : 'assets/icons/biology.png'),
                ),
                const SizedBox(width: 10),
                Text(
                  subject,
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
