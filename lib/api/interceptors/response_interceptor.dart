import 'package:dio/dio.dart';
import 'package:flutter_make_music/api/app_response.dart';

// import 'package:get/get.dart' hide Response;
// import 'package:flutter_make_music/utils/extension/get_extension.dart';

// 响应拦截
class ResponseInterceptors extends InterceptorsWrapper {
  @override
  onResponse(Response response) async {
    return response;
  }
}
