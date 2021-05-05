import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/bang_menu.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:flutter_make_music/utils/constants.dart';
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
          final widgets = <Widget>[];
          data?.bangMenu?.forEach((bangType) {
            final bangTypeWidgets = <Widget>[_buildHead(bangType.name)];
            bangType?.list?.forEach((item) {
              bangTypeWidgets.add(
                GestureDetector(
                    onTap: () => Get.toNamed(Routes.RankDetial,
                        arguments: {'id': item.sourceid, 'label': item.name}),
                    child: Container(
                      width: Get.width / 3 - 8,
                      margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
                      child: Stack(
                        children: [
                          Image.network(
                            "${item.pic}",
                          ),
                          Positioned(
                            child: Text(
                              "${item.pub}",
                              style: TextStyle(fontSize: 12),
                            ),
                            bottom: 10,
                            left: 10,
                          ),
                          Positioned(
                            child: Icon(
                              Icons.play_circle_fill_outlined,
                              size: 20,
                            ),
                            right: 10,
                            bottom: 10,
                          ),
                        ],
                      ),
                    )),
              );
            });
            widgets.add(Wrap(
              children: bangTypeWidgets,
            ));
          });
          widgets.add(SizedBox(
            height: Constants.miniPlayerHeight,
          ));
          return FutureBuilder(
              future: controller.future.value,
              builder: (c, s) {
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
                    widget = ListView.builder(
                        itemCount: widgets.length,
                        itemBuilder: (c, i) {
                          return widgets[i];
                        });
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

  _buildHead(String name) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text("$name"),
    );
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
