import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:get/get.dart';

var xRefreshHeader = ClassicalHeader(
    completeDuration: Duration(milliseconds: 300),
    showInfo: false,
    refreshedText: "",
    refreshReadyText: "释放刷新",
    refreshingText: "正在刷新...",
    refreshText: "下拉刷新",
    textColor: Get.theme.hoverColor,
    refreshFailedText: "");

var xRefreshFooter = ClassicalFooter(
  completeDuration: Duration(milliseconds: 300),
  showInfo: false,
  loadedText: "",
  loadReadyText: "释放加载",
  loadingText: "正在加载...",
  loadText: "下拉加载",
  padding: EdgeInsets.only(bottom: Constants.miniPlayerHeight),
  textColor: Get.theme.hoverColor,
);
