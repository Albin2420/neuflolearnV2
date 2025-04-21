import 'dart:developer';

import 'package:get/get.dart';
import 'package:neuflo_learn/src/data/repositories/stats/stats_repo_impl.dart';
import 'package:neuflo_learn/src/data/repositories/token/token_repo_impl.dart';
import 'package:neuflo_learn/src/domain/repositories/stats/stats_repo.dart';
import 'package:neuflo_learn/src/domain/repositories/token/token_repo.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/controller/profile/profile_controller.dart';

class Navigationcontroller extends GetxController {
  // final ctrlr = Get.put(ProfileController());
  final ctr = Get.find<AppStartupController>();
  TokenRepo trp = TokenRepoImpl();
  RxBool isLoading = false.obs;
  var statsData = {}.obs;
  RxInt currentIndex = RxInt(0);
  StatsRepo stRepo = StatsRepoImpl();
  RxString docName = RxString('');

  @override
  void onInit() async {
    super.onInit();
    log("Navigationcontroller initialized");
    if (ctr.appUser.value?.id != 0) {
      setId(ctr.appUser.value?.id ?? 0);
    }
    docName.value = "${ctr.appUser.value?.phone}@neuflo.io";
    log("docName:$docName");
  }

  Future setId(int id) async {
    log("id:$id");
    ctr.studentId.value = id;
    // await ctrlr.fetchweekgrowth(); // for profiler
    update();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
