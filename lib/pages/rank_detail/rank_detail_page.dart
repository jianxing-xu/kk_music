import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_make_music/model/song.dart';

import 'package:flutter_make_music/pages/rank_detail/controller.dart';
import 'package:flutter_make_music/services/global_state.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/widget/loading_page_widget.dart';
import 'package:flutter_make_music/widget/refresh_header.dart';
import 'package:get/get.dart';

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
                    var label = Get.arguments['label'];
                    return SliverAppBar(
                        pinned: true,
                        expandedHeight: 240,
                        collapsedHeight: 60,
                        title: Obx(() => Opacity(
                              opacity: controller.percent.value ?? 0,
                              child: Text("${label ?? ''}"),
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
                                          playService.loadListAndPlay(
                                              0, controller.bang.musicList);
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
    return EasyRefresh(
      controller: controller.erctrl,
      header: xRefreshHeader,
      footer: xRefreshFooter,
      onRefresh: () async {
        await controller.pagingState.reset();
        controller.bang.musicList.clear();
        await controller.loadData();
      },
      onLoad: () async {
        controller.pagingState.nextPage();
        if (controller.pagingState.isEnd) {
          controller.erctrl.finishLoad(noMore: true);
          print("-----------------到底了-------------------");
          return;
        }
        await controller.loadData();
      },
      child: GetBuilder(
        builder: (_) {
          List<Song> list = controller?.bang?.musicList ?? [];
          return LoadingPage(
              callback: () async {
                controller.pageNetState.init();
                controller.update();
                await controller.loadData();
              },
              loading:
                  controller?.pageNetState?.loading ?? controller?.bang == null,
              error: controller.pageNetState.error,
              child: Column(
                children: _buildSongList(list),
              ));
        },
        init: controller,
      ),
    );
  }

  List<Widget> _buildSongList(List<Song> list) {
    print("构建SONG_LIST: $list");
    var widgets = <Widget>[];
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        Song item = list[i];
        widgets.add(ListTile(
          onTap: () {
            playService.loadListAndPlay(i, list);
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
