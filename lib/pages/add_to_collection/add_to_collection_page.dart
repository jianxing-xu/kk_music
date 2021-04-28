import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/search_result.dart';
import 'package:flutter_make_music/model/song.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:flutter_make_music/utils/pagin_state.dart';
import 'package:flutter_make_music/widget/base/loading.dart';
import 'package:flutter_make_music/widget/refresh_header.dart';
import 'package:flutter_make_music/widget/search_input.dart';
import 'package:flutter_make_music/utils/extension/get_extension.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddToCollectionPageController extends GetxController {
  final key = "".obs;
  final paging = PagingState();
  final selected = Rx<List<Song>>([]);
  TextEditingController controller = TextEditingController();
  RefreshController refreshController = RefreshController();
  Rx<List<Song>> result = Rx<List<Song>>(null);
  Rx<Future> future = Rx<Future>(null);

  search() {
    future.value = Provider.getSearchResult(key.value).then((res) {
      if (res.ok) {
        final data = SearchResult.fromJson(res.data);
        paging.total = data.total;
        result(data.list);
        return data;
      } else {
        return Future.error(res.error.msg);
      }
    });
  }

  load() {
    if (paging.isEnd) {
      return refreshController.loadNoData();
    }
    Provider.getSearchResult(key.value).then((res) {
      if (res.ok) {
        final data = SearchResult.fromJson(res.data);
        paging.total = data.total;
        result.update((val) {
          val.addAll(data.list);
        });
        refreshController.loadComplete();
      } else {
        print(res.error.msg);
        refreshController.loadFailed();
      }
    });
  }

  @override
  void onReady() {
    controller.addListener(() => key(controller.text));
    debounce(key, (String value) {
      search();
      selected.value = [];
    });
    super.onReady();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}

typedef HandleAction = Future<bool> Function(List<Song> value);

class AddToCollectionPage extends StatelessWidget {
  final HandleAction action;
  AddToCollectionPage({this.action});

  final controller = Get.put(AddToCollectionPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          height: 50,
          margin: EdgeInsets.only(top: 30),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              SearchInput(
                enabled: true,
                title: "关键词",
                controller: controller.controller,
                tapSuffix: () {},
                onFocus: (bool b) {},
              ),
              SizedBox(
                width: 10,
              ),
              Obx(() => controller.selected.value.length != 0
                  ? GestureDetector(
                      onTap: () {
                        Get.loading();
                        action(controller.selected.value).then((bool b) {
                          Fluttertoast.showToast(msg: "操作成功");
                        }).catchError((e) {
                          Fluttertoast.showToast(msg: "操作失败");
                        }).whenComplete(() {
                          Get.dismiss();
                        });
                      },
                      child: Text("完成"),
                    )
                  : SizedBox())
            ],
          ),
        ),
      ),
      body: Obx(() {
        final list = controller.result.value;
        final selected = controller.selected.value;
        if (controller.key.value.isEmpty) return SizedBox();
        return FutureBuilder(
            future: controller.future.value,
            builder: (c, s) {
              Widget widget;
              if (s.connectionState == ConnectionState.done) {
                if (s.hasError) {
                  widget = Center(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.search();
                      },
                      child: Text("点击重试"),
                    ),
                  );
                } else {
                  widget = Column(
                    children: [
                      Expanded(
                          child: SmartRefresher(
                        controller: controller.refreshController,
                        enablePullUp: true,
                        onLoading: controller.load,
                        enablePullDown: false,
                        footer: refreshFooter(controller.refreshController),
                        child: ListView(
                          children: List.generate(list?.length ?? 0, (index) {
                            final song = list[index];
                            return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: selected
                                        .indexWhere((v) => v.rid == song.rid) !=
                                    -1,
                                title: Text("${song.name}"),
                                subtitle: Text("${song.artist}"),
                                onChanged: (bool b) {
                                  final index = selected
                                      .indexWhere((v) => v.rid == song.rid);
                                  controller.selected.update((val) {
                                    if (index == -1)
                                      val.add(song);
                                    else
                                      val.removeAt(index);
                                  });
                                });
                          }),
                        ),
                      )),
                      SizedBox(
                        height: Constants.miniPlayerHeight,
                      )
                    ],
                  );
                }
              } else {
                widget = Center(
                  child: Loading(),
                );
              }
              return widget;
            });
      }),
    );
  }
}
