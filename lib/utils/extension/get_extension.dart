import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// 扩展 Get 小组件，增加了 loading 和 移除 loading

extension GetExtension on GetInterface {
  dismiss() {
    print("dismiss: ${Get.isDialogOpen}");
    if (Get.isDialogOpen) {
      Get.back();
    }
  }

  loading() {
    this.dismiss();
    Get.dialog(LoadingDialog());
  }
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
            key: key,
            backgroundColor: Get.theme.primaryColor,
            children: <Widget>[
              Center(
                child: CupertinoActivityIndicator(),
              )
            ]));
  }
}
