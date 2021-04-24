import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base/loading.dart';

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
        return Container(
          padding: EdgeInsets.only(top: 25),
          alignment: Alignment.center,
          child: body,
        );
      },
    );
