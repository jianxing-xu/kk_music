import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_make_music/services/dio_config_service.dart';
import 'package:get/get.dart' hide Response;

// import 'package:flutter_make_music/utils/extension/get_extension.dart';
// import 'package:get/get.dart' hide Response;

// token 拦截器，(实际上是请求拦截)
class TokenInterceptors extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    // print("TOKEN 请求拦截，");
    //授权码
    // var authorizationCode = await getAuthorization();
    // options.headers["Authorization"] = authorizationCode;

    // kuwo csrf认证
    options.headers['csrf'] = getCSRF();

    // print(options.headers.toString());
    return options;
  }

  @override
  onResponse(Response response) async {
    return response;
  }

  ///清除授权
  clearAuthorization() {}

  ///获取授权token
  getAuthorization() async {
    String token = "563492ad6f91700001000001b801c7451e82434d924781e2bc999f1a";
    return token;
  }

  getCSRF() {
    List<Cookie> cookies = PersistCookieJar(dir: DioConfig.cookiesPath)
        .loadForRequest(Uri.parse(DioConfig.baseUrl));
    String kwtoken = "";
    cookies.forEach((c) {
      if (c.name.contains("kw_token")) {
        kwtoken = c.value;
      }
    });
    return kwtoken;
  }
}
