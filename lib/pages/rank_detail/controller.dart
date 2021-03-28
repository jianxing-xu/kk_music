import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/bang_menu.dart';
import 'package:flutter_make_music/utils/page_netstate.dart';
import 'package:flutter_make_music/utils/pagin_state.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class RankDetailController extends GetxController {
  final percent = 0.0.obs;
  ScrollController scrollController = ScrollController();

  String id;

  EasyRefreshController erctrl = EasyRefreshController();
  PageNetState pageNetState = PageNetState();
  PagingState pagingState = PagingState();

  BangDetail bang;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    scrollController.addListener(() {
      if (scrollController.position.pixels <= 140) {
        percent.value = (scrollController.position.pixels / 140).toDouble();
      }
    });
  }

  @override
  void onReady() async {
    super.onReady();
    await loadData();
  }

  loadData() async {
    try {
      var res = await Provider.getRankDetail(id,
          pn: pagingState.page, rn: pagingState.pageNum);
      if (res.ok) {
        if (bang == null) {
          bang = BangDetail.fromJson(res.data);
        } else {
          bang.musicList.addAll(BangDetail.fromJson(res.data).musicList);
        }
        pagingState.total = int.parse(bang.num ?? 0);
        pageNetState.success();
      }
    } catch (e) {
      pageNetState.thError();
      // pagingState.reset();
    } finally {
      update();
    }
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    erctrl.dispose();
  }
}
