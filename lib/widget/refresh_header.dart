import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart' hide CustomFooter;
import 'package:flutter_make_music/utils/constants.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base/loading.dart';

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

var refreshHeader = ClassicHeader(
  height: 45.0,
  releaseText: '松开手刷新',
  refreshingText: '',
  completeText: '刷新完成',
  failedText: '刷新失败',
  idleText: '下拉刷新',
  refreshingIcon: Loading(),
);

var refreshFooter = (RefreshController controller) => CustomFooter(
      builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text("加载更多");
        } else if (mode == LoadStatus.loading) {
          body = Loading();
        } else if (mode == LoadStatus.failed) {
          body = GestureDetector(
            child: Text("点击重试"),
            onTap: () => controller.requestLoading(),
          );
        } else if (mode == LoadStatus.canLoading) {
          body = Text("上拉加载更多");
        } else {
          body = Text("到底了");
        }
        return Center(
          child: body,
        );
      },
    );
