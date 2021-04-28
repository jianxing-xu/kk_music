import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_make_music/api/interceptors/response_interceptor.dart';
import 'package:flutter_make_music/api/interceptors/token_interceptor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DioConfig {
  static String baseUrl = "https://kuwo.cn";

  static String userBaseUrl = "http://169.254.21.188:4000/api/";

  static String proxy = "";

  static String cookiesPath;

  static List<Interceptor> interceptors = [
    TokenInterceptors(),
    ResponseInterceptors()
  ];

  static init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = join(appDocDir.path, "cookies/");
    cookiesPath = path;
  }
}
