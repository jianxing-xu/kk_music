import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/bang_menu.dart';
import 'package:flutter_make_music/widget/base/loading.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankPageContoller extends GetxController {
  Rx<Future> future = Rx<Future>(null);
  Rx<BangModel> data = Rx<BangModel>(null);
  RefreshController refreshController = RefreshController();

  loadData([refresh = false]) {
    final f = Provider.getRankList().then(((res) {
      if (res.ok) {
        final result = BangModel.fromJson(res.data);
        data(result);
        return result;
      } else {
        return Future.error(res.error.msg);
      }
    }));
    if (!refresh) {
      future(f);
    }
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }
}

class RankPage extends StatelessWidget {
  final controller = Get.put(RankPageContoller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("排行榜"),
        ),
        body: Obx(() {
          final data = controller.data.value;
          return FutureBuilder(
              future: controller.future.value,
              builder: (c, s) {
                final widgets = <Widget>[];
                data?.bangMenu?.forEach((bangType) {
                  widgets.add(ListTile(
                    onTap: () {
                      Get.to(() => RankPage2(
                            bangType: bangType,
                          ));
                    },
                    title: Text("${bangType.name}"),
                  ));
                });
                Widget widget;
                if (s.connectionState == ConnectionState.done) {
                  if (s.hasError) {
                    widget = Center(
                      child: ElevatedButton(
                        onPressed: () => controller.loadData(),
                        child: Text("点击重试"),
                      ),
                    );
                  } else {
                    widget = SmartRefresher(
                      controller: controller.refreshController,
                      child: ListView(
                        children: widgets,
                      ),
                    );
                  }
                } else {
                  widget = Center(
                    child: Loading(),
                  );
                }
                return widget;
              });
        }));
  }
}

class RankPage2 extends StatelessWidget {
  final BangType bangType;
  RankPage2({this.bangType});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${bangType.name}"),
      ),
      body: Container(),
    );
  }
}
