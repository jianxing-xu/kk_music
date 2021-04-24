import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_make_music/api/app_response.dart';
import 'package:flutter_make_music/services/dio_config_service.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultSendTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class DioX with DioMixin implements Dio {
  DioX({BaseOptions options}) {
    this.options = options;
    interceptors
        .add(CookieManager(PersistCookieJar(dir: DioConfig.cookiesPath)));
    if (DioConfig.interceptors?.isNotEmpty ?? false) {
      interceptors.addAll(DioConfig.interceptors);
    }
    httpClientAdapter = DefaultHttpClientAdapter();
  }

  // 用户接口实例
  static DioX d2 = DioX(
      options: BaseOptions(
          baseUrl: DioConfig.userBaseUrl,
          contentType: 'application/json',
          connectTimeout: _defaultConnectTimeout,
          sendTimeout: _defaultSendTimeout,
          receiveTimeout: _defaultReceiveTimeout,
          responseType: ResponseType.json));
  // 酷我接口实例
  static DioX d1 = DioX(
      options: BaseOptions(
          baseUrl: DioConfig.baseUrl,
          contentType: 'application/json',
          connectTimeout: _defaultConnectTimeout,
          sendTimeout: _defaultSendTimeout,
          receiveTimeout: _defaultReceiveTimeout,
          responseType: ResponseType.json));
}

class DioClient {
  DioX get d1 => DioX.d1;
  DioX get d2 => DioX.d2;

  Future<AppResponse> request(String url,
      {String method = "GET",
      data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      ProgressCallback onReceiveProgress,
      Options options}) async {
    try {
      options ??= Options(method: method);

      options?.method = method;
      var res = await d1.request(url,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          options: options);
      return AppResponse.handle(res);
    } on DioError catch (e) {
      return AppResponse.errorExp(e: e, res: e.response);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<AppResponse> reqUsr(String url,
      {String method = "GET",
      data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      ProgressCallback onReceiveProgress,
      Options options}) async {
    try {
      options ??= Options(method: method);
      options.method = method;
      var res = await d2.request(url,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          options: options);
      return AppResponse.handle(res);
    } on DioError catch (e) {
      return AppResponse.errorExp(e: e, res: e.response);
    }
  }
}
