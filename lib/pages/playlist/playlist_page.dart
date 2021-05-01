import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/play_list.dart';
import 'package:flutter_make_music/pages/home/body/playlist_card.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:flutter_make_music/utils/pagin_state.dart';
import 'package:flutter_make_music/widget/base/loading.dart';
import 'package:flutter_make_music/widget/refresh_header.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlayListController extends GetxController {
  PagingState paging = PagingState();
  Rx<Future> future = Rx<Future>(null);
  Rx<PlayListAll> data = Rx<PlayListAll>(null);

  RefreshController refreshController = RefreshController();
  final type = true.obs;

  loadData([refresh = false]) {
    final f = Provider.getAllPlayList(
            paging.page, paging.pageNum, type.value ? 'hot' : 'new')
        .then((res) {
      if (res.ok) {
        final result = PlayListAll.fromJson(res.data);
        data(result);
        paging.total = result.total;
        refreshController.refreshCompleted();
        return result;
      } else {
        refreshController.refreshFailed();
        return Future.error(res.error.msg);
      }
    });
    if (!refresh) {
      future.value = f;
    }
  }

  loadMore() {
    if (paging.isEnd) {
      return refreshController.loadNoData();
    }
    paging.nextPage();
    Provider.getAllPlayList(
            paging.page, paging.pageNum, type.value ? 'hot' : 'new')
        .then((res) {
      if (res.ok) {
        final result = PlayListAll.fromJson(res.data);
        data.update((val) {
          val.data.addAll(result.data);
        });
        refreshController.loadComplete();
        return result;
      } else {
        refreshController.loadFailed();
        return Future.error(res.error.msg);
      }
    });
  }

  @override
  void onReady() {
    loadData();
    ever(type, (value) {
      refreshController.requestRefresh();
    });
    super.onReady();
  }
}

class PlayListPage extends StatelessWidget {
  final controller = Get.put(PlayListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("歌单"),
        centerTitle: false,
        actions: [
          Obx(() {
            final type = controller.type;
            return Row(
              children: [
                ChoiceChip(
                  label: Text("热门"),
                  selected: type.value == true,
                  onSelected: (bool b) => type.toggle(),
                ),
                SizedBox(
                  width: 3,
                ),
                ChoiceChip(
                    label: Text("最新"),
                    selected: type.value == false,
                    onSelected: (bool b) => type.toggle())
              ],
            );
          })
        ],
      ),
      body: Obx(() {
        final data = controller.data.value;
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
                  widget = Column(
                    children: [
                      Expanded(
                        child: SmartRefresher(
                          enablePullUp: true,
                          controller: controller.refreshController,
                          header: refreshHeader,
                          footer: refreshFooter(controller.refreshController),
                          onRefresh: () => controller.loadData(true),
                          onLoading: controller.loadMore,
                          child: GridView.builder(
                              itemCount: data.data?.length ?? 0,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 1 / 1.45,
                                      mainAxisSpacing: 4),
                              itemBuilder: (c, index) {
                                final item = data?.data[index];
                                return PlayListCardWidget(playListItem: item);
                              }),
                        ),
                      ),
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
