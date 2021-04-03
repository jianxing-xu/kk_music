import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_make_music/pages/search/search_controller.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:flutter_make_music/widget/refresh_header.dart';
import 'package:flutter_make_music/widget/search_input.dart';
import 'package:get/get.dart';

// TODO: 搜索出错 容错处理。

class SearchPage extends StatelessWidget {
  final logic = Get.put(SearchController());

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
                title: "歌手/歌曲",
                controller: logic.searchController,
                onChange: (v) => logic.keyword.value = v,
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Obx(() {
          return IndexedStack(
            index: logic.indexed,
            children: [NormalView(), SuggestView(), ResultView()],
          );
        }),
      ),
    );
  }
}

class NormalView extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
          children: [
            Container(
              height: 40,
              child: Row(
                children: [
                  Container(
                    child: Text("历史"),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 30,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: buildChip("JayZhou"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: buildChip("JayZhou"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: buildChip("JayZhou"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: buildChip("JayZhou"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: buildChip("JayZhou"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: buildChip("JayZhou"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: buildChip("JayZhou"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: buildChip("JayZhou"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: buildChip("JayZhou"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: buildChip("JayZhou"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Icon(Icons.delete),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "热门搜索",
                      style: Get.theme.textTheme.headline6,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  Wrap(
                    children: List.generate(
                      controller.hotKeys.length,
                      (index) {
                        var item = controller.hotKeys[index];
                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 5),
                          child: GestureDetector(
                            onTap: () {
                              controller.searchKeys.clear();
                              controller.keyword.value = item;
                              controller.searchController.text = item;
                            },
                            child: buildChip(item),
                          ),
                        );
                      },
                    ).toList(),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
          border: Border.all(color: Get.theme.hoverColor),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }
}

class SuggestView extends GetView<SearchController> {
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        var widgets = <Widget>[];
        // 添加第一个搜索词
        widgets.add(GestureDetector(
          onTap: () {
            controller.search();
          },
          child: ListTile(
            title: Text(
              "搜索：\"${controller.keyword.value}\"",
              style: TextStyle(color: Get.theme.highlightColor),
            ),
          ),
        ));
        widgets.addAll(List.generate(controller.searchKeys.length, (index) {
          var item = controller.searchKeys[index];
          return ListTile(
            title: Text("$item"),
          );
        }).toList());
        // 添加最后一个占位高度
        widgets.add(SizedBox(
          height: Constants.miniPlayerHeight,
        ));
        return ListView(
          children: widgets,
        );
      }),
    );
  }
}

class ResultView extends GetView<SearchController> {
  final player = Get.find<PlayerService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 40,
            child: TabBar(
                isScrollable: true,
                indicatorColor: Get.theme.highlightColor,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                controller: controller.tabController,
                tabs: [Text("单曲"), Text("歌手")]),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildSongResult(),
                _buildArtistResult(),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildSongResult() {
    return EasyRefresh(
      header: xRefreshHeader,
      footer: xRefreshFooter,
      controller: controller.easyController,
      onLoad: () async {
        if (controller.pagingState.isEnd) {
          controller.easyController.finishLoad(noMore: true, success: true);
        } else {
          await controller.search();
        }
      },
      child: Obx(() {
        var list = controller.result.value?.list;
        if (controller.error.value) {
          return Center(
            child: ElevatedButton(
              onPressed: () => controller.search(),
              child: Text("点击重试"),
            ),
          );
        }
        if (list == null) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        var widgets = <Widget>[];
        list.forEach((song) {
          widgets.add(ListTile(
            onTap: () {
              player.insertSongInPlayList(song);
            },
            leading: Icon(Icons.music_note),
            title: Text("${song.name} - ${song.artist}"),
          ));
        });
        return Column(
          children: widgets,
        );
      }),
    );
  }

  _buildArtistResult() {
    return EasyRefresh(
      header: xRefreshHeader,
      footer: xRefreshFooter,
      controller: controller.easyController,
      onLoad: () async {
        print(controller.pagingState);
        if (controller.pagingState.isEnd) {
          controller.easyController.finishLoad(noMore: true, success: true);
        } else {
          await controller.search(type: "Artist");
        }
      },
      child: Obx(() {
        var list = controller.result.value?.artistList;
        if (list == null) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        var widgets = <Widget>[];
        list.forEach((artist) {
          var avatar = CircleAvatar(
            child: artist.pic != null ? Image.network(artist.pic) : SizedBox(),
            backgroundColor: Get.theme.backgroundColor,
          );
          widgets.add(ListTile(
            leading: avatar,
            title: Text("${artist.name}"),
          ));
        });
        return Column(
          children: widgets,
        );
      }),
    );
  }
}
