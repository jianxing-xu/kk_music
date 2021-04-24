import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_make_music/pages/home/body/app_bar.dart';
import 'package:flutter_make_music/pages/home/body/tab_view1.dart';
import 'package:flutter_make_music/pages/home/body/tab_view2.dart';
import 'package:flutter_make_music/pages/home/home_controller.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final logic = Get.put<HomeController>(HomeController());

  final tab1Key = PageStorageKey("tab1");
  final tab2Key = PageStorageKey("tab2");

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
    );
  }
}
