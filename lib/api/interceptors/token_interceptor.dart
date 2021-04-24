import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_make_music/services/dio_config_service.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';

// token 拦截器，(实际上是请求拦截)
class TokenInterceptors extends InterceptorsWrapper {
  final box = Get.find<GetStorage>();
  @override
  onRequest(RequestOptions options) async {
    options.headers['csrf'] = getCSRF();
    options.headers['authorization'] = getAuthorization();
    print("[Request]: Method: ${options.method}, Uri: ${options.uri}");
    return options;
  }

  @override
  Future onResponse(Response response) async {
    return response;
  }

  ///获取授权token
  getAuthorization() {
    String token = box.read("token");
    return "Bearer $token";
  }

  // 从本地cookie获取kw_token
  getCSRF() {
    List<Cookie> cookies = PersistCookieJar(dir: DioConfig.cookiesPath)
        .loadForRequest(Uri.parse(DioConfig.baseUrl));
    String kwToken = "";
    cookies.forEach((c) {
      if (c.name.contains("kw_token")) {
        kwToken = c.value;
      }
    });
    return kwToken;
  }
}
