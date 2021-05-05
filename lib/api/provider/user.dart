import 'package:flutter_make_music/api/app_response.dart';
import 'package:flutter_make_music/api/dio_client.dart';
import 'package:flutter_make_music/model/song.dart';
import 'package:get/get.dart';

class UserApi {
  static final client = Get.find<DioClient>();

  static Future<AppResponse> login(String username, String password) {
    return client.reqUsr("/auth/login",
        method: "POST",
        data: <String, dynamic>{'username': username, 'password': password});
  }

  static Future<AppResponse> register(String username, String password) {
    return client.reqUsr("/user/register",
        method: "POST",
        data: <String, dynamic>{'username': username, 'password': password});
  }

  static Future<AppResponse> getInfo() {
    return client.reqUsr("/user/userinfo", method: "GET");
  }

  static Future<AppResponse> updateInfo(String username) {
    return client.reqUsr("/user/updateInfo/" + username, method: "POST");
  }

  static Future<AppResponse> updatePwd(String oldPwd, String newPwd) {
    return client.reqUsr("/user/updatePwd/$oldPwd/$newPwd", method: "POST");
  }

  static Future<AppResponse> toggleFavorite(String rid) {
    return client.reqUsr("/user/toggleFavorite/$rid");
  }

  //favoriteMulSong
  static Future<AppResponse> favoriteMulSong(String ids) {
    return client.reqUsr("/user/favoriteMulSong/$ids");
  }

  static Future<AppResponse> addListenCount() {
    return client.reqUsr("/user/addListenCount");
  }

  static Future<AppResponse> createPlaylist(String name) {
    return client.reqUsr("/playlist/create/$name", method: "POST");
  }

  static Future<AppResponse> getSongByIds(String ids) {
    return client.reqUsr("/song/findByIds/$ids");
  }

  static Future<AppResponse> addSongToDB(Song song) {
    return client.reqUsr("/song/addSong", method: "POST", data: {
      'name': song.name,
      'artist': song.artist,
      'pic': song.pic,
      'id': song.rid
    });
  }

  static Future<AppResponse> addMulSongToDB(List<Song> songs) {
    final data = songs
        .map((song) => {
              'name': song.name,
              'artist': song.artist,
              'pic': song.pic,
              'id': song.rid
            })
        .toList();
    return client.reqUsr("/song/addMulSong", method: "POST", data: data);
  }

  // 查找歌单详情
  static Future<AppResponse> findPlaylistInfo(int id) {
    return client.reqUsr("/playlist/findById/$id");
  }

  // 删除歌单中多个歌曲addToPlaylist
  static Future<AppResponse> removeSongForPlaylist(int id, String ids) {
    return client.reqUsr("/playlist/removeForPlaylist/$id",
        method: "POST", queryParameters: {'ids': ids});
  }

  static Future<AppResponse> addSongToPlaylist(int id, String ids) {
    return client.reqUsr("/playlist/addToPlaylist/$id",
        method: "POST", queryParameters: {'ids': ids});
  }

  static Future<AppResponse> findAllPlaylist() {
    return client.reqUsr("/playlist/findAllByUser");
  }

  static Future<AppResponse> removeMulPlaylist(String ids) {
    return client.reqUsr("/playlist/removeMul/$ids", method: "POST");
  }
}
