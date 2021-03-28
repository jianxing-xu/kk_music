import 'dart:io';
import 'package:dio/dio.dart';

// 自定义 App 异常
class AppException implements Exception {
  // 错误消息
  final String _message;
  String get message => _message ?? this.runtimeType.toString();

  // 错误码
  final int _code;
  int get code => _code ?? -1;

  AppException([this._message, this._code]);

  String toString() {
    return "code:$code--message=$message";
  }

  factory AppException.handle(String error) {
    return UnknowException(error);
  }

  factory AppException.handleException(Exception error) {
    // 判断 是否是Dio中发生的异常，对 Dio 中的异常处理
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.DEFAULT:
          if (error.error is SocketException) {
            // SocketException: Failed host lookup: '***'
            // (OS Error: No address associated with hostname, errno = 7)
            return NetworkException(error.error.message);
          } else {
            return UnknowException(error.error.message);
          }
          break;
        case DioErrorType.CONNECT_TIMEOUT:
        case DioErrorType.RECEIVE_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
          return NetworkException(error.error.message);
        case DioErrorType.RESPONSE:
          return HttpException(error.error.message, error.response.statusCode);
        case DioErrorType.CANCEL:
          return CancelException(error.error.message);
          break;
        default:
          // 其他情况就作为   “拉取数据异常”
          return FetchDataException(error.error.message);
      }
    } else {
      // 其他情况就作为   “拉取数据异常”
      return FetchDataException(error.toString());
    }
  }
}

// http 异常
class HttpException extends AppException {
  HttpException([String message, int code]) : super(message, code);
}

// 获取数据异常
class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(
          message,
        );
}

// 未知异常
class UnknowException extends AppException {
  UnknowException([String message])
      : super(
          message,
        );
}

// Dio 取消请求异常
class CancelException extends AppException {
  CancelException([String message])
      : super(
          message,
        );
}

// 网络异常
class NetworkException extends AppException {
  NetworkException([String message])
      : super(
          message,
        );
}
