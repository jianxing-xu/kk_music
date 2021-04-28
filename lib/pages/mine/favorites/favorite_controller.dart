import 'package:flutter_make_music/api/provider/user.dart';
import 'package:flutter_make_music/model/song.dart';
import 'package:flutter_make_music/model/user.dart';
import 'package:flutter_make_music/services/user.service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoriteController extends GetxController {
  final userService = Get.find<UserService>();

  final Rx<Future> future = Rx<Future>(null);

  final Rx<List<Song>> songs = Rx<List<Song>>(null);

  final RefreshController refreshController = RefreshController();

  cancelFavorite(int index, int rid) {
    userService.toggleFavorite("$rid").then((value) {
      songs.update((val) {
        val.removeAt(index);
      });
    });
  }

  loadData([bool refresh = false]) async {
    final ids = userService.user.value?.favorites ?? "";
    Future f = UserApi.getSongByIds(ids).then((res) {
      if (res.ok) {
        songs.value = (res.data as List).map((e) => Song.fromJson(e)).toList();
        refreshController.refreshCompleted();
        return songs.value;
      } else {
        return Future.error(res.error.msg);
      }
    });
    if (!refresh) {
      future.value = f;
    }
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }
}
