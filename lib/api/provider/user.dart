import 'package:flutter_make_music/api/app_response.dart';
import 'package:flutter_make_music/api/dio_client.dart';
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
}
