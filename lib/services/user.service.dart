import 'package:flutter_make_music/api/provider/user.dart';
import 'package:flutter_make_music/model/user.dart';
import 'package:flutter_make_music/pages/signin_or_register/signin_register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserService extends GetxService {
  final box = Get.find<GetStorage>();
  final isLogin = false.obs; // 是否登录
  final Rx<User> user = Rx<User>(null); // 用户信息

  login(String username, String password) async {
    final res = await UserApi.login(username, password);
    if (res.ok) {
      var data = User.fromJson(res.data);
      box.write("token", data.token);
      user(data);
      isLogin(true);
      return "success";
    } else {
      return "${res.error.msg}";
    }
  }

  register(String username, String password) async {
    final res = await UserApi.register(username, password);
    return res.ok;
  }

  getInfo() async {
    final res = await UserApi.getInfo();
    if (res.ok) {
      var data = User.fromJson(res.data);
      user(data);
      isLogin(true);
    } else {
      logout();
    }
  }

  logout() {
    user.value = null;
    isLogin(false);
    box.remove("token");
  }

  Future updateInfo(String username) async {
    final res = await UserApi.updateInfo(username);
    if (res.ok) {
      return res.data;
    } else {
      return Future.error(res.error.msg);
    }
  }

  Future toggleFavorite(String rid) async {
    if (!isLogin.value) {
      Get.to(RegsiterOrSignin());
      Fluttertoast.showToast(msg: "请先登录");
      return Future.error(false);
    }
    final res = await UserApi.toggleFavorite(rid);
    if (res.ok) {
      user.update((val) {
        final ids = val.favorites?.split(",") ?? [];
        if (res.data) {
          ids.add(rid);
        } else {
          ids.remove(rid.toString());
        }
        val.favorites = ids.join(",");
      });
      return true;
    } else {
      return Future.error(res.error.msg);
    }
  }

  autoCheck() {
    getInfo();
  }

  @override
  void onReady() {
    autoCheck();
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
  }
}
