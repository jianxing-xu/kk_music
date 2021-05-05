import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_make_music/pages/home/body/app_bar.dart';
import 'package:flutter_make_music/pages/home/body/tab_view1.dart';
import 'package:flutter_make_music/pages/home/body/tab_view2.dart';
import 'package:flutter_make_music/pages/home/home_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final logic = Get.put<HomeController>(HomeController());

  final tab1Key = PageStorageKey("tab1");
  final tab2Key = PageStorageKey("tab2");
  final Rx<DateTime> _lastQuitTime = Rx<DateTime>(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        tabController: logic?.tabController,
      ),
      body: TabBarView(
        controller: logic?.tabController,
        children: [TabView1(), TabView2()],
      ),
      bottomSheet: WillPopScope(
          onWillPop: () async {
            if (_lastQuitTime.value == null ||
                DateTime.now().difference(_lastQuitTime.value).inSeconds > 1) {
              Fluttertoast.showToast(msg: "再按一次退出应用");
              _lastQuitTime.value = DateTime.now();
              return false;
            } else {
              Get.back();
              return true;
            }
          },
          child: SizedBox()),
    );
  }
}
