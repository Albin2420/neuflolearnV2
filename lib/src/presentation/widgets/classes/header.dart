import 'package:flutter/material.dart';
import 'package:neuflo_learn/src/core/config/theme/colors.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        gradient: RadialGradient(
          center: Alignment.bottomRight,
          radius: 1.0,
          colors: [AppColors.gradientEnd, AppColors.statusBarColor],
          stops: [0.5, 0.8],
        ),
      ),
    );
  }
}
