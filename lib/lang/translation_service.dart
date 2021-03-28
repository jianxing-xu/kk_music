// 定义一个语言库
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_make_music/lang/de_DE.dart';
import 'package:flutter_make_music/lang/zh_CN.dart';

class TranslationService extends Translations {
  static final locale = Get.deviceLocale;
  static final fallbackLocale = Locale("en_US");
  @override
  Map<String, Map<String, String>> get keys => {'zh_CN': zh_CN, 'de_DE': de_DE};
}
