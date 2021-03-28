// 对响应做统一的处理
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_make_music/api/app_exception.dart';

// 统一数据响应格式
class AppResponse {
  bool _ok;

  bool get ok => _ok ?? false;

  dynamic _data;

  dynamic get data => _data;

  AppException _error;

  AppException get error => _error ?? AppException();

  factory AppResponse.handle(Response response) {
    try {
      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          response.data != null) {
        return AppResponse._handleSuccessData(response.data);
      }
      if (response.data == null) {
        return AppResponse._error(errorMsg: "data is empty !");
      }

      return AppResponse._errorForException(
          HttpException(response.statusMessage, response.statusCode));
    } catch (e) {}
    var data = json.decode(response.data);
    print("HANDLE_SUCCESS_RESPONSE_PRE: ${data}");
    if (data['url'] != null) {
      print("--------------URL--------------");
      return AppResponse._handleUrl(data);
    }
    return AppResponse._handleSuccessData(json.decode(response.data));
  }

  AppResponse._handleUrl(Map<String, dynamic> data) {
    if (data['code'] == 200) {
      _data = data['url'];
      _ok = true;
      _error = null;
    } else {
      _data = null;
      _ok = false;
      _error = AppException.handle("http成功了，确实URL！");
    }
  }

  // Http状态成功构造函数
  // ignore: unused_element
  AppResponse._httpSuccess([dynamic data]) {
    // _data = data;
    // _ok = true;
    // AppResponse._handleSuccessData(data);
  }

  // 失败构造函数(仅消息)
  AppResponse._error({String errorMsg}) {
    _error = AppException.handle(errorMsg);
    _data = null;
    _ok = false;
  }

  // 发生错误构造函数（处理异常对象）
  AppResponse._errorForException(Exception error) {
    _error = AppException.handleException(error);
    _data = null;
    _ok = false;
  }

  // TODO: 处理 code: xx, data: xx, success: xx，在这里http请求是成功的！
  AppResponse._handleSuccessData([Map<String, dynamic> data]) {
    print("HANDLE_SUCCESS: $data");
    if (data['code'] == 200) {
      _data = data['data'];
      _ok = true;
      _error = null;
    } else {
      _data = null;
      _ok = false;
      _error = AppException.handle("http成功了，确实其他状态码！");
    }
  }
}
