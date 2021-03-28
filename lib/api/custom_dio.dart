import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_make_music/services/dio_config_service.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultSendTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

// 自定义 Dio，对 Dio 做一些修改配置
class AppDio with DioMixin implements Dio {
  AppDio._([BaseOptions options]) {
    options ??= BaseOptions(
      baseUrl: DioConfig.baseUrl,
      contentType: 'application/json',
      connectTimeout: _defaultConnectTimeout,
      sendTimeout: _defaultSendTimeout,
      receiveTimeout: _defaultReceiveTimeout,
    );

    this.options = options;

    //DioCacheManager， LRU 缓存策略
    // interceptors.add(DioCacheManager(
    //   CacheConfig(
    //     baseUrl: DioConfig.baseUrl,
    //   ),
    // ).interceptor);

    //Cookie管理,cookie 将会保存到本地
    interceptors
        .add(CookieManager(PersistCookieJar(dir: DioConfig.cookiesPath)));

    if (DioConfig.interceptors?.isNotEmpty ?? false) {
      interceptors.addAll(DioConfig.interceptors);
    }
    // 在 debug 模式下， 文档建议在末尾添加日志拦截器
    if (kDebugMode) {
      // interceptors.add(LogInterceptor(
      //     responseBody: true,
      //     error: true,
      //     requestHeader: false,
      //     responseHeader: false,
      //     request: false,
      //     requestBody: true));
    }

    httpClientAdapter = DefaultHttpClientAdapter();
  }

  setProxy(String proxy) {
    (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      // config the http client
      client.findProxy = (uri) {
        //proxy all request to localhost:8888
        return "PROXY $proxy";
      };
      // you can also create a HttpClient to dio
      // return HttpClient();
    };
  }

  static Dio getInstance([BaseOptions options]) => AppDio._(options);
}
