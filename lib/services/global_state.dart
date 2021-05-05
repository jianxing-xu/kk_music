import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:get/get.dart';

class GlobalState extends GetxController {
  final currentRoutePath = ''.obs;
  final isOpenBottomSheet = false.obs;
  final index = 0.obs;

  final themeHack = false.obs;

  change(int i) {
    index.value = i;
  }

  // min 播放器的偏移
  double get miniPlayerOffset {
    if (currentRoutePath.value == Routes.Player ||
        isOpenBottomSheet.value ||
        currentRoutePath.value == Routes.RegisterOrSignin) {
      return -(Constants.barHeight);
    }
    if (['/', '/Home', '/Mine'].contains(currentRoutePath.value)) return 0;
    return -(Constants.bottomBarHeight);
  }

  updateDateThemeHack() {
    themeHack.toggle();
    update();
  }
}
