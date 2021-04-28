import 'package:dio/dio.dart';
import 'package:flutter_make_music/api/app_response.dart';
import 'package:flutter_make_music/api/dio_client.dart';

import 'package:get/get.dart';

abstract class Provider {
  static final client = Get.find<DioClient>();

  // 用于刷新cookie中的kw_token
  static void refreshCookie() {
    client.request("/url?format=mp3&rid=12312&response=url&type=convert_url3",
        queryParameters: {'format': 'mp3'}).then((value) {});
  }

  /// 获取首页数据
  static Future<AppResponse> getHomeData() async {
    return client.request("http://m.kuwo.cn/newh5app/api/mobile/v1/home");
  }

  /// 获取排行榜
  static Future<AppResponse> getRankList() async {
    return client.request("/api/www/bang/bang/bangMenu");
  }

  /// 获取排行榜详情
  static Future<AppResponse> getRankDetail(String bangId,
      {int pn = 1, int rn = 30}) async {
    return client.request("/api/www/bang/bang/musicList",
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
      't': DateTime.now().millisecond,
      'httpsStatus': '1'
    };
    return client.request('/url', queryParameters: param);
  }

  // 获取歌词
  static Future<AppResponse> getLyric(String rid, CancelToken cancelToken) {
    return client.request(
        "http://m.kuwo.cn/newh5app/api/mobile/v1/music/info/$rid",
        cancelToken: cancelToken);
  }

  // 搜索建议（为空时，十个热门）
  static Future<AppResponse> getSearchKey(
      [String key = "", CancelToken cancelToken]) {
    return client.request("/api/www/search/searchKey",
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

  // 搜索音乐 Music Artist /api/www/search/searchMusicBykeyWord?key=maobuyi
  static Future<AppResponse> getSearchResult(
      [String key = "", String type = "Music", int pn = 1, int rn = 30]) {
    return client.request("/api/www/search/search${type}BykeyWord",
        queryParameters: {'key': key, 'httpsStatus': 1, 'pn': pn, 'rn': rn},
        options: Options(
            headers: {'Host': 'kuwo.cn', 'Referer': 'https://kuwo.cn/'}));
  }

  // 歌单详情
  static Future<AppResponse> getPlayListDetail(String id,
      [int pn = 1, int rn = 30]) {
    return client.request("/api/www/playlist/playListInfo",
        queryParameters: {'pid': id, 'httpsStatus': 1, 'pn': pn, 'rn': rn},
        options: Options(
            headers: {'Host': 'kuwo.cn', 'Referer': 'https://kuwo.cn/'}));
  }
}
