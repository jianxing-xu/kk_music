import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/home_model.dart';
import 'package:flutter_make_music/utils/page_netstate.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  PageNetState pageNetState = PageNetState();
  HomeModel model;
  RefreshController refreshController;
  TabController tabController;

  Future homeFuture;

  loadData() {
    homeFuture = Provider.getHomeData().then((res) {
      if (res.ok) {
        model = HomeModel.fromJson(res.data);
        update();
        return model;
      } else {
        return Future.error(res.error.msg);
      }
    });
    update();
  }

  refreshData() async {
    var res = await Provider.getHomeData();
    if (res.ok) {
      model = HomeModel.fromJson(res.data);
      update();
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshFailed();
      return Future.error(res.error.msg);
    }
  }

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  @override
  void onClose() {
    super.onClose();
    refreshController.dispose();
    tabController.dispose();
  }
}
