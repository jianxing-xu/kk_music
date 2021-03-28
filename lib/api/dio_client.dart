import 'package:dio/dio.dart';
import 'package:flutter_make_music/api/app_response.dart';
import 'package:get/get.dart';
import 'custom_dio.dart';

// 自定义封装请求的方法 get post put patch...

class DioClient {
  // 获取 实例
  AppDio _dio = AppDio.getInstance();

  AppDio get dio => _dio;

  // AppDio _dioo = AppDio.getInstance(BaseOptions(baseUrl: "http://other"));

  Future<AppResponse> get(String uri,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onReceiveProgress,
      bool errorTip = true}) async {
    try {
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return AppResponse.handle(response);
    } catch (e) {
      // 没获取到response对象，抛出异常
      if (errorTip) Get.snackbar("提示", "网络错误");
      throw e;
    }
  }

  Future<AppResponse> post(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return AppResponse.handle(response);
    } catch (e) {
      throw e;
    }
  }

  Future<AppResponse> patch(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      var response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return AppResponse.handle(response);
    } catch (e) {
      throw e;
    }
  }

  Future<AppResponse> delete(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  }) async {
    try {
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return AppResponse.handle(response);
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<AppResponse> put(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  }) async {
    try {
      var response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return AppResponse.handle(response);
    } catch (e) {
      throw e;
    }
  }
}
