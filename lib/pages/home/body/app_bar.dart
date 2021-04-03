// 首页顶部AppBar
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:flutter_make_music/widget/base/loading.dart';
import 'package:get/get.dart';

class MyAppBar extends PreferredSize {
  final TabController tabController;

  MyAppBar({@required this.tabController});

  @override
  Widget get child => Container(
        // color: Get.theme.primaryColor,
        height: 70,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
                child: TabBar(
                    isScrollable: true,
                    indicatorColor: Get.theme.highlightColor,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: tabController,
                    tabs: [Icon(Icons.music_note), Icon(Icons.cloud)])),
            Expanded(
                flex: 1,
                child: Container(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.Search);
                    },
                    child: Icon(
                      Icons.search,
                      color: Get.theme.textTheme.bodyText1.color,
                    ),
                  ),
                  alignment: Alignment.bottomRight,
                )),
          ],
        ),
      );

  // 预设大小
  @override
  Size get preferredSize => Size.fromHeight(60);
}
