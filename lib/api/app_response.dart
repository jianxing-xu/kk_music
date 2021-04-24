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
    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        response.data != null) {
      // 处理 请求 kuwo url 返回 Failed 问题
      if (response.data.toString() == "failed") {
        print("FAILED");
        return AppResponse.errorMsg(errorMsg: "酷我 神奇的 failed!");
      }
      // 处理 URL 返回的 response 是 String 问题
      var data = response.data.runtimeType.toString() == "String"
          ? jsonDecode(response.data)
          : response.data;
      if (data['url'] != null) {
        return AppResponse._handleUrl(data);
      }
      return AppResponse._handleSuccessData(data);
    }
    return AppResponse.errorMsg(errorMsg: response.statusMessage);
  }

  // 失败构造函数(仅消息)
  AppResponse.errorMsg({String errorMsg}) {
    _error = AppException(errorMsg);
    _data = null;
    _ok = false;
  }

  // 发生错误构造函数（处理异常对象）
  AppResponse.errorExp({Response res, DioError e}) {
    if (res != null) {
      _error = AppException.handleResponse(res);
    } else {
      _error = AppException.handleException(e);
    }
    _data = null;
    _ok = false;
  }

  //  处理 code: xx, data: xx, success: xx，在这里http请求是成功的！
  AppResponse._handleSuccessData([Map<String, dynamic> data]) {
    // 这里可以处理自定的http状态
    if (data['code'] == 200) {
      _data = data['data'];
      _ok = true;
      _error = null;
    } else {
      _data = null;
      _ok = false;
      _error = AppException("${data['message']}");
    }
  }
  // 处理 .mp3 返回结果
  AppResponse._handleUrl(Map<String, dynamic> data) {
    if (data['code'] == 200) {
      _data = data['url'];
      _ok = true;
      _error = null;
    } else {
      _data = null;
      _ok = false;
      _error = AppException("http成功了，确实URL！");
    }
  }

  @override
  String toString() {
    return 'AppResponse{ok: $_ok, data: $_data, error: $_error}';
  }
}
