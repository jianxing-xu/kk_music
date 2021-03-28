import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/home_model.dart';
import 'package:flutter_make_music/utils/page_netstate.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  PageNetState pageNetState = PageNetState();
  HomeModel model;
  EasyRefreshController easyRefreshController;
  TabController tabController;

  loadData() async {
    pageNetState.init();
    try {
      var res = await Provider.getHomeData();
      if (res.data == null) throw "网络错误";
      model = HomeModel.fromJson(res.data);
      pageNetState.success();
    } catch (e) {
      print(e);
      pageNetState.thError();
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    easyRefreshController = EasyRefreshController();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onReady() async {
    super.onReady();
    loadData();
  }

  @override
  void onClose() {
    super.onClose();
    easyRefreshController.dispose();
    tabController.dispose();
  }
}
