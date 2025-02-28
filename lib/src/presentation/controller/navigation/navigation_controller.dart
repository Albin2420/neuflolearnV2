import 'dart:developer';

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
    await fetchfromApi(); // for statuspage
    await ctrlr.fetchweekgrowth(); // for profiler
    if (statsData != {}) {
      isLoading.value = true;
    }
    update();
  }

  Future<void> fetchfromApi({int retryCount = 0, int maxRetries = 3}) async {
    log("fetchfromApi() attempt: $retryCount");

    final result =
        await stRepo.fetchStatus(accessToken: await ctr.getAccessToken() ?? '');

    result.fold((f) async {
      log("Error in fetchfromApi(): ${f.message}");

      if (f.message == "user is not authorised") {
        if (retryCount < maxRetries) {
          final tokens = await trp.getNewTokens(
              refreshToken: await ctr.getRefreshToken() ?? "");

          tokens.fold((l) {
            log("Failure in fetchfromApi() new token: ${l.message}");
          }, (r) async {
            await ctr.saveToken(
                accessToken: r["access_token"],
                refreshToken: r["refresh_token"]);

            // Retry fetchfromApi with an incremented retry count
            await fetchfromApi(
                retryCount: retryCount + 1, maxRetries: maxRetries);
          });
        } else {
          log("Max retries reached. Unable to fetch data.");
        }
      } else {
        log("Error in fetchfromApi(): ${f.message}");
      }
    }, (r) {
      statsData.value = r;
      // log("statsData: ${statsData["practice_test_stats"]}");
    });
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Future<void> rebuild({required bool rebuild}) async {
    if (rebuild) {
      try {
        await ctrlr.fetchweekgrowth();
        await fetchfromApi();
        update();
      } catch (e) {
        log("Error in rebuild():$e");
      }
    }
  }
}
