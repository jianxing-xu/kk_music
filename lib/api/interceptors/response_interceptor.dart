import 'package:dio/dio.dart';
// import 'package:get/get.dart' hide Response;
// import 'package:flutter_make_music/utils/extension/get_extension.dart';

// 响应拦截
class ResponseInterceptors extends InterceptorsWrapper {
  @override
  onResponse(Response response) async {
    print("DioResponse数据正常请求拦截");
    return response;
  }
}
