import 'dart:developer';

import 'package:get/get.dart';
import 'package:neuflo_learn/src/data/repositories/profile/profile_repo_impl.dart';
import 'package:neuflo_learn/src/data/repositories/token/token_repo_impl.dart';
import 'package:neuflo_learn/src/domain/repositories/profile/profile_repo.dart';
import 'package:neuflo_learn/src/domain/repositories/token/token_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';

class ProfileController extends GetxController {
  final appctr = Get.find<AppStartupController>();
  TokenRepo trp = TokenRepoImpl();
  ProfileRepo prf = ProfileRepoImpl();
  RxDouble sec = RxDouble(0);
  RxDouble phySics = RxDouble(0);
  RxDouble chemIstry = RxDouble(0);
  RxDouble bioLogy = RxDouble(0);
  RxDouble totalPerc = RxDouble(0);

  Future<void> fetchweekgrowth() async {
    try {
      final prData = await prf.fetchweekGrowth(
          accestoken: await appctr.getAccessToken() ?? '');

      prData.fold((l) async {
        log("Error in fetchweekgrowth():${l.message}");
      }, (R) async {
        sec.value = (R["time"] ?? 0 as num).toDouble();
        phySics.value = (R["physics"] ?? 0 as num).toDouble();
        chemIstry.value = (R["chemistry"] ?? 0 as num).toDouble();
        bioLogy.value = (R["biology"] ?? 0 as num).toDouble();

        totalPerc.value = phySics.value + chemIstry.value + bioLogy.value;
      });

      //handle
    } catch (e) {
      log("Error:$e");
    }
  }
}
