import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/play_list.dart';
import 'package:flutter_make_music/utils/pagin_state.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlayListDetailController extends GetxController {
  String id;

  RefreshController refreshController = RefreshController();

  PagingState pagingState = PagingState();

  Rx<PlayList> data = Rx<PlayList>(null);

  Rx<Future> future = Rx<Future>(null);

  // 歌单详情数据回调
  loadData() {
    future.value =
        Provider.getPlayListDetail(id, pagingState.page, pagingState.pageNum)
            .then((res) {
      if (res.ok) {
        try {
          var model = PlayList.fromJson(res.data);
          data.value = model;
          pagingState.total = model.total;
          return model;
        } catch (e) {
          return Future.error(res.error.msg);
        }
      } else {
        return Future.error(res.error.msg);
      }
    });
  }

  refreshData() {
    Provider.getPlayListDetail(id, pagingState.page, pagingState.pageNum)
        .then((res) {
      if (res.ok) {
        var model = PlayList.fromJson(res.data);
        data.value = model;
        refreshController.refreshCompleted();
      } else {
        refreshController.refreshFailed();
        throw "${res.error.msg}";
      }
    });
  }

  loadMore() {
    if (pagingState.isEnd) return refreshController.loadNoData();
    pagingState.nextPage();
    Provider.getPlayListDetail(id, pagingState.page, pagingState.pageNum)
        .then((res) {
      if (res.ok) {
        var model = PlayList.fromJson(res.data);
        data.update((val) {
          val.musicList.addAll(model.musicList);
        });
        refreshController.loadComplete();
      } else {
        refreshController.loadFailed();
        throw "PLAY_LIST_DETAIL_ERROR";
      }
    });
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }

  @override
  void onInit() {
    id = Get.arguments['id'];
    print("歌单id： $id");
    super.onInit();
  }
}
