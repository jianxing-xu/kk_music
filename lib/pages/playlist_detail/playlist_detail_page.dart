import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/model/play_list.dart';
import 'package:flutter_make_music/pages/playlist_detail/controller.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:flutter_make_music/widget/base/loading.dart';
import 'package:flutter_make_music/widget/refresh_header.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlayListDetail extends StatelessWidget {
  final controller = Get.put(PlayListDetailController());
  final player = Get.find<PlayerService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        title: Obx(() => Text("${controller.data?.value?.name ?? '--'}")),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      var data = controller.data?.value;
      var songs = data?.musicList;
      return FutureBuilder(
          future: controller.future?.value,
          builder: (c, state) {
            Widget widget;
            if (state.connectionState == ConnectionState.done) {
              if (state.hasError) {
                widget = Center(
                  child: ElevatedButton(
                    onPressed: controller.loadData,
                    child: Text("点击重试"),
                  ),
                );
              } else {
                widget = Column(
                  children: [
                    Expanded(
                        child: SmartRefresher(
                      controller: controller.refreshController,
                      onRefresh: controller.refreshData,
                      onLoading: controller.loadMore,
                      enablePullUp: true,
                      header: refreshHeader,
                      footer: refreshFooter(controller.refreshController),
                      child: ListView(
                        children: [
                          //  歌单头部
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            width: Get.width,
                            height: 200,
                            color: Colors.black26,
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    child: data?.img != null
                                        ? Image.network(
                                            "${data?.img}",
                                            fit: BoxFit.contain,
                                          )
                                        : SizedBox(),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  // 右侧信息
                                  Expanded(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // 歌单名
                                        child: Text("${data?.name}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      // 制作人
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                                NetworkImage("${data?.uPic}"),
                                            maxRadius: 10,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            "${data?.userName}",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),

                                      // 简介
                                      Container(
                                        child: Text(
                                          "简介：${data?.info}",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Get.theme.hoverColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      ActionChip(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                          label: Text(
                                            "播放全部",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          onPressed: () {
                                            player.setPlayList(songs);
                                            player.setCurrentIndex(0);
                                            Get.toNamed(Routes.Player);
                                          }),
                                      // Container(
                                      //   padding: EdgeInsets.symmetric(
                                      //       vertical: 4, horizontal: 6),
                                      //   decoration: BoxDecoration(
                                      //       color: Get.theme.highlightColor,
                                      //       borderRadius:
                                      //           BorderRadius.circular(15)),
                                      //   child: Text(
                                      //     "播放全部",
                                      //     style: TextStyle(
                                      //         color: Get.theme.backgroundColor,
                                      //         fontWeight: FontWeight.w500,
                                      //         fontSize: 12),
                                      //   ),
                                      // ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ]..addAll(List.generate(songs?.length ?? 0, (index) {
                            var song = songs[index];
                            return ListTile(
                              onTap: () {
                                player.setPlayList(songs);
                                player.setCurrentIndex(index);
                              },
                              leading: Text("${index + 1}"),
                              title: Text("${song.name} - ${song.artist}"),
                            );
                          })),
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
    });
  }
}
