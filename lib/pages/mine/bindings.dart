import 'package:flutter_make_music/pages/mine/mine_controller.dart';
import 'package:get/instance_manager.dart';

class MineBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MineController>(() => MineController());
  }
}
