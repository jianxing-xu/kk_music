import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/model/song.dart';

import 'package:flutter_make_music/pages/rank_detail/controller.dart';
import 'package:flutter_make_music/services/global_state.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:flutter_make_music/widget/base/loading.dart';
import 'package:flutter_make_music/widget/refresh_header.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankDetail extends StatelessWidget {
  final controller = Get.put(RankDetailController());
  final playService = Get.find<PlayerService>();
  final globalState = Get.find<GlobalState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.primaryColor,
        body: NestedScrollView(
          controller: controller.scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              GetBuilder(
                  init: controller,
                  builder: (_) {
                    return SliverAppBar(
                        pinned: true,
                        expandedHeight: 240,
                        collapsedHeight: 60,
                        title: Obx(() => Opacity(
                              opacity: controller.percent.value ?? 0,
                              child: Text("${controller.label ?? ''}"),
                            )),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(40),
                          child: Container(
                            width: Get.width,
                            height: 40,
                            color: Get.theme.primaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: PhysicalModel(
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                color: Get.theme.backgroundColor,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "共${controller?.bang?.num ?? 0}首",
                                      style: Get.theme.textTheme.headline6,
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  side: BorderSide(),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Get.theme.primaryColor),
                                        ),
                                        onPressed: () {
                                          playService.setPlayList(
                                              controller.bang?.musicList);
                                          playService.next();
                                        },
                                        child: Text('播放全部'))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: controller?.bang?.img != null
                              ? FadeInImage(
                                  placeholder:
                                      AssetImage("assets/images/bg.jpg"),
                                  image:
                                      NetworkImage("${controller?.bang?.img}"),
                                  fit: BoxFit.contain,
                                  width: 100,
                                )
                              : SizedBox(),
                        ));
                  }),
            ];
          },
          body: _buildBody(),
        )

        // slivers: [_buildHeader(), _buildBody()]),
        );
  }

  Widget _buildBody() {
    return GetBuilder(
      builder: (_) {
        List<Song> list = controller?.bang?.musicList ?? [];
        return FutureBuilder(
            future: controller.future,
            builder: (c, snapshot) {
              Widget widget;
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
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
                        enablePullDown: true,
                        controller: controller.refreshController,
                        onLoading: controller.loadMore,
                        onRefresh: controller.refreshData,
                        footer: refreshFooter(controller.refreshController),
                        header: refreshHeader,
                        child: ListView(
                          children: _buildSongList(list),
                        ),
                      )),
                      SizedBox(
                        height: Constants.miniPlayerHeight,
                      )
                    ],
                  );
                }
              } else {
                widget = Container(
                  child: Loading(),
                );
              }
              return widget;
            });
      },
      init: controller,
    );
  }

  List<Widget> _buildSongList(List<Song> list) {
    var widgets = <Widget>[];
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        Song item = list[i];
        widgets.add(ListTile(
          onTap: () {
            var f = playService.playList?.indexWhere((v) => v.rid == item.rid);
            if (f != -1 && playService.playList != null) {
              print("在列表中找到了这首歌");
              playService.setCurrentIndex(i);
            } else {
              print("新的播放列表");
              playService.setPlayList(list);
              playService.setCurrentIndex(i);
            }
          },
          title: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(children: [
              TextSpan(text: "${i + 1}    "),
              TextSpan(text: "${item.name}     "),
            ]),
          ),
          trailing: Container(
            width: 100,
            child: Text(
              "${item.artist}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Get.theme.hoverColor),
            ),
          ),
        ));
      }
    }
    return widgets;
  }
}
