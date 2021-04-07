import 'package:dio/dio.dart';
import 'package:flutter_make_music/api/app_response.dart';
import 'package:flutter_make_music/api/dio_client.dart';
import 'package:flutter_make_music/services/dio_config_service.dart';

import 'package:get/get.dart';

abstract class Provider {
  static final client = Get.find<DioClient>();

  // 用于刷新cookie中的kw_token
  static void refreshCookie() {
    client
        .get("/url?format=mp3&rid=12312&response=url&type=convert_url3",
            queryParameters: {'format': 'mp3'}, errorTip: false)
        .then((value) {});
  }

  /// 获取首页数据
  static Future<AppResponse> getHomeData() async {
    return client.get("http://m.kuwo.cn/newh5app/api/mobile/v1/home");
  }

  /// 获取排行榜
  static Future<AppResponse> getRankList() async {
    return client.get("/api/www/bang/bang/bangMenu");
  }

  /// 获取排行榜详情
  static Future<AppResponse> getRankDetail(String bangId,
      {int pn = 1, int rn = 30}) async {
    return client.get("/api/www/bang/bang/musicList",
        queryParameters: {'bangId': bangId, 'pn': pn, 'rn': rn});
  }

  // 获取MP3资源
  static Future<AppResponse> getUri(String rid) async {
    var param = <String, dynamic>{
      'format': 'mp3',
      'rid': '$rid',
      'response': 'url',
      'type': 'convert_url3',
      'br': '128kmp3',
      'from': 'web',
      't': '1616763431316',
      'httpsStatus': '1'
    };
    var res = await client.dio.get('/url', queryParameters: param);
    return AppResponse.handle(res);
  }

  // 获取歌词
  static Future<AppResponse> getLyric(String rid) {
    return client
        .get("http://m.kuwo.cn/newh5app/api/mobile/v1/music/info/$rid");
  }

  // 搜索建议（为空时，十个热门）
  static Future<AppResponse> getSearchKey(
      [String key = "", CancelToken cancelToken]) {
    return client.get("/api/www/search/searchKey",
        queryParameters: {
          'key': key,
          'httpsStatus': 1,
          "reqId": "596d10a0-91ff-11eb-95eb-affa89622a46"
        },
        cancelToken: cancelToken,
        options: Options(headers: {
          'Host': 'kuwo.cn',
          'Referer': 'https://kuwo.cn/',
        }));
  }

  // 搜索音乐 Music Artist
  static Future<AppResponse> getSearchResult(
      [String key = "", String type = "Music", int pn = 1, int rn = 30]) {
    return client.get("/api/www/search/search${type}BykeyWord",
        queryParameters: {'key': key, 'httpsStatus': 1, 'pn': pn, 'rn': rn},
        options: Options(
            headers: {'Host': 'kuwo.cn', 'Referer': 'https://kuwo.cn/'}));
  }
}
