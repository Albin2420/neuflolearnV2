import 'dart:developer';

import 'package:get/get.dart';
import 'package:neuflo_learn/src/core/data_state/data_state.dart';
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

  Rx<Ds> profileState = Rx(Initial());

  Future<void> fetchweekgrowth() async {
    try {
      profileState.value = Loading();
      final prData = await prf.fetchweekGrowth(
          accestoken: await appctr.getAccessToken() ?? '');

      prData.fold((l) async {
        profileState.value = Failed();
      }, (R) async {
        sec.value = (R["time"] ?? 0 as num).toDouble();
        phySics.value = (R["physics"] ?? 0 as num).toDouble();
        chemIstry.value = (R["chemistry"] ?? 0 as num).toDouble();
        bioLogy.value = (R["Biology"] ?? 0 as num).toDouble();
        totalPerc.value = (R['totalPercentage'] ?? 0 as num).toDouble();

        log("Physics:${phySics.value},chemistry:${chemIstry.value},biology:${bioLogy.value}, percent:${totalPerc.value}");
        profileState.value = Success(data: R);
      });
    } catch (e) {
      log("Error:$e");
      profileState.value = Failed();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchweekgrowth();
  }
}
