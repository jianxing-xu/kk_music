import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/bang_menu.dart';
import 'package:flutter_make_music/utils/pagin_state.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankDetailController extends GetxController {
  String id; // props id
  String label;

  final percent = 0.0.obs; // 头部透明比例

  BangDetail bang; // 数据

  ScrollController scrollController = ScrollController(); // 滚动控制

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  PagingState pagingState = PagingState();

  // 异步加载状态
  Future future;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    label = Get.arguments['label'];
    scrollController.addListener(() {
      if (scrollController.position.pixels <= 140) {
        percent.value = (scrollController.position.pixels / 140).toDouble();
      }
    });
  }

  @override
  void onReady() async {
    super.onReady();
    loadData();
  }

  // 首次加载数据
  loadData() {
    future = Provider.getRankDetail(id,
            pn: pagingState.page, rn: pagingState.pageNum)
        .then((res) {
      if (res.ok) {
        bang = BangDetail.fromJson(res.data);
        pagingState.total = int.parse(bang.num);
        update();
        return bang;
      }
    }).catchError((e) {
      throw "RANK_LIST_REQ_ERROR";
    });
    update();
  }

  // 加载更多数据
  loadMore() async {
    pagingState.nextPage();
    if (pagingState.isEnd) return refreshController.loadNoData();
    try {
      var res = await Provider.getRankDetail(id,
          pn: pagingState.page, rn: pagingState.pageNum);
      if (res.ok) {
        var data = BangDetail.fromJson(res.data);
        bang.musicList.addAll(data.musicList);
        update();

        refreshController.loadComplete();
      }
    } catch (e) {
      refreshController.loadFailed();
      pagingState.page--;
    }
  }

  // 刷新数据
  refreshData() async {
    pagingState.reset();
    try {
      var res = await Provider.getRankDetail(id,
          pn: pagingState.page, rn: pagingState.pageNum);
      if (res.ok) {
        bang = BangDetail.fromJson(res.data);
        update();
        refreshController.refreshCompleted();
      }
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    refreshController.dispose();
  }
}
