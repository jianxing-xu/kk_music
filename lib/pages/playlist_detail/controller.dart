import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/play_list.dart';
import 'package:flutter_make_music/utils/pagin_state.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PlayListDetailController extends GetxController {
  String id;
  PagingState pagingState = PagingState();
  Rx<PlayList> data;

  Rx<Future> future;

  // TODO: 歌单详情数据回调
  loadData() {
    future.value =
        Provider.getPlayListDetail(id, pagingState.page, pagingState.pageNum)
            .then((res) {
      if (res.ok) {
        data.value = PlayList.fromJson(res.data);
        return data.value;
      }
    }).catchError((e) {
      throw "PLAY_LIST_DETAIL_ERROR";
    });
  }

  refreshData() {}

  loadMore() {}

  @override
  void onInit() {
    id = Get.arguments['id'];
    super.onInit();
  }
}
