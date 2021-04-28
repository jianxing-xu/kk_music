// 统一在app启动前注入依赖

import 'package:flutter_make_music/services/global_state.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/services/user.service.dart';
import 'package:get/get.dart';
import 'package:flutter_make_music/api/dio_client.dart';
import 'package:flutter_make_music/services/dio_config_service.dart';
import 'package:flutter_make_music/services/get_storage_box_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // get_storage 实例
    await Get.putAsync(() => GetStorageBox().init());

    await DioConfig.init();
    // dio_client
    Get.put(DioClient());
    Get.put(UserService());
    // 播放器状态
    Get.put<PlayerService>(PlayerService());
    // 全局状态
    Get.put(GlobalState(), permanent: true);
  }
}
