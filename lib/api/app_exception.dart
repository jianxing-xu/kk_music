import 'package:dio/dio.dart';

// 自定义 App 异常
class AppException implements Exception {
  // 错误消息
  final String _msg;
  String get msg => _msg ?? this.runtimeType.toString();

  // 错误码
  final int _code;
  int get code => _code ?? -1;

  // 处理普通消息异常
  AppException([this._msg, this._code]);

  String toString() {
    return "AppExeption { code: $code, msg: $msg}";
  }

  // 处理异常状态下的Response
  factory AppException.handleResponse(Response response) {
    // 如果返回异常对象 data 中有 msg 不然就用 http 失败 msg
    String msg = response.data['msg'] ?? response.statusMessage;
    return AppException(msg, response.statusCode);
  }

  factory AppException.handleException(DioError e) {
    AppException exception;
    switch (e.type) {
      case DioErrorType.DEFAULT:
        exception = AppException("网络错误", -1);
        break;
      case DioErrorType.CANCEL:
        exception = AppException("取消请求", -1);
        break;
      case DioErrorType.RESPONSE:
        exception = AppException("响应错误", -1);
        break;
      case DioErrorType.SEND_TIMEOUT:
        exception = AppException("发送超时", -1);
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        exception = AppException("连接超时", -1);
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        exception = AppException("接收超时", -1);
        break;
      default:
        exception = AppException("未知错误", -1);
        break;
    }
    return exception;
  }
}
