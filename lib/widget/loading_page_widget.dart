import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingPage extends StatelessWidget {
  final Widget child;

  final bool loading;

  final bool error;

  final Function callback;

  LoadingPage({this.child, this.loading, this.error, this.callback});

  @override
  Widget build(BuildContext context) {
    print("BUILD_LOADING_PAGE{loading: $loading}");
    return error
        ? errorWidget
        : loading
            ? loadingWidget
            : child;
  }

  Widget get errorWidget => Container(
        width: Get.width,
        height: Get.height * 0.7,
        child: Center(
          child: ElevatedButton(
            onPressed: () => callback(),
            child: Text("网络错误点击重试"),
          ),
        ),
      );

  Widget get loadingWidget => Container(
        width: Get.width,
        height: Get.height * 0.7,
        child: Center(child: CupertinoActivityIndicator()),
      );
}
