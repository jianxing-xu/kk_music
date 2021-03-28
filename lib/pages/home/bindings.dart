import 'package:flutter_make_music/pages/home/home_controller.dart';
import 'package:get/instance_manager.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<HomeController>(() async {
      return HomeController();
    });
  }
}
