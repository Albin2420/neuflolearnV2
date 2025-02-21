import 'dart:developer';

import 'package:get/get.dart';
import 'package:neuflo_learn/src/data/repositories/stats/stats_repo_impl.dart';
import 'package:neuflo_learn/src/domain/repositories/stats/stats_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';

class Navigationcontroller extends GetxController {
  final ctr = Get.find<AppStartupController>();
  var statsData = {}.obs;
  RxInt currentIndex = RxInt(0);
  StatsRepo stRepo = StatsRepoImpl();

  @override
  void onInit() {
    super.onInit();

    if (ctr.appUser.value?.id != 0) {
      setId(ctr.appUser.value?.id ?? 0);
    }
    fetchfromApi();
  }

  void setId(int id) {
    log("id:$id");
    ctr.studentId.value = id;
  }

  void fetchfromApi() async {
    final result = await stRepo.fetchStatus(studentId: ctr.studentId.value);
    result.fold((f) {
      log("failure");
    }, (r) {
      statsData.value = r;
    });
    log("statsData:$statsData");
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
