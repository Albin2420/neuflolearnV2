import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neuflo_learn/src/data/repositories/stats/stats_repo_impl.dart';
import 'package:neuflo_learn/src/data/repositories/token/token_repo_impl.dart';
import 'package:neuflo_learn/src/domain/repositories/stats/stats_repo.dart';
import 'package:neuflo_learn/src/domain/repositories/token/token_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/controller/profile/profile_controller.dart';

class Navigationcontroller extends GetxController {
  final ctrlr = Get.put(ProfileController());
  final ctr = Get.find<AppStartupController>();
  TokenRepo trp = TokenRepoImpl();
  RxBool isLoading = false.obs;
  var statsData = {}.obs;
  RxInt currentIndex = RxInt(0);
  StatsRepo stRepo = StatsRepoImpl();

  @override
  void onInit() async {
    super.onInit();
    log("Navigationcontroller initialized");
    if (ctr.appUser.value?.id != 0) {
      setId(ctr.appUser.value?.id ?? 0);
    }
  }

  Future setId(int id) async {
    log("id:$id");
    ctr.studentId.value = id;
    await weeklystats(); // for statuspage
    await ctrlr.fetchweekgrowth(); // for profiler
    if (statsData != {}) {
      isLoading.value = true;
    }
    update();
  }

  Future<void> weeklystats() async {
    final result =
        await stRepo.weeklystats(accessToken: await ctr.getAccessToken() ?? '');

    result.fold((f) async {
      log("Error in weeklystats(): ${f.message}");

      // if (f.message == "user is not authorised") {
      //   if (retryCount < maxRetries) {
      //     final tokens = await trp.getNewTokens(
      //         refreshToken: await ctr.getRefreshToken() ?? "");

      //     tokens.fold((l) {
      //       log("Failure in fetchfromApi() new token: ${l.message}");
      //     }, (r) async {
      //       await ctr.saveToken(
      //           accessToken: r["access_token"],
      //           refreshToken: r["refresh_token"]);

      //       // Retry fetchfromApi with an incremented retry count
      //       await weeklystats(
      //           retryCount: retryCount + 1, maxRetries: maxRetries);
      //     });
      //   } else {
      //     log("Max retries reached. Unable to fetch data.");
      //   }
      // } else {
      //   log("Error in weeklystats(): ${f.message}");
      // }
    }, (r) {
      statsData.value = r;
    });
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Future<void> rebuild({required bool rebuild}) async {
    if (rebuild) {
      try {
        EasyLoading.show();
        await ctrlr.fetchweekgrowth();
        await weeklystats();
        update();
        EasyLoading.dismiss();
      } catch (e) {
        log("Error in rebuild():$e");
      }
    }
  }
}
