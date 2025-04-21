import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';

class ProfiLeLoading extends StatelessWidget {
  const ProfiLeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Constant.screenHeight,
      width: Constant.screenWidth,
      child: Center(
        child: SizedBox(
          height: 200,
          child: Lottie.asset('assets/loading.json'),
        ),
      ),
    );
  }
}
