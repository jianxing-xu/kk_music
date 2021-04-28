import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_make_music/model/song.dart';
import 'package:flutter_make_music/pages/player/player_page.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:flutter_make_music/widget/base/loading.dart';
import 'package:get/get.dart';

class MiniPlayer extends GetView<PlayerService> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
          onTap: () {
            Get.to(Player(), transition: Transition.upToDown);
          },
          child: Container(
            width: Get.width,
            height: Constants.miniPlayerHeight,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Stack(
              children: [
                PhysicalModel(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    color: Get.theme.backgroundColor,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(Icons.music_video_rounded),
                        ),
                        Expanded(
                            child: Container(
                          child: Text(
                            "${controller?.song?.value?.name ?? ''} - ${controller?.song?.value?.artist ?? ''}",
                            style: Get.theme.textTheme.bodyText2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                        GestureDetector(
                          onTap: () => controller.previous(),
                          child: Icon(Icons.chevron_left),
                        ),
                        GestureDetector(
                          onTap: () => controller.next(),
                          child: Icon(Icons.chevron_right),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.playing.value
                                ? controller.pause()
                                : controller.play();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: controller.playing.value
                                ? Icon(Icons.pause)
                                : Icon(Icons.play_arrow),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //  播放列表
                            Get.bottomSheet(BuildBottomSheet());
                          },
                          child: controller.playList.length > 0
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(Icons.queue_music),
                                )
                              : SizedBox(),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 36,
                    right: 10,
                    child: LinearProgressIndicator(
                      value: controller?.percent?.value,
                      minHeight: 1,
                      // backgroundColor: Get.theme.hintColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Get.theme.highlightColor),
                    )),
                if (controller?.song?.value?.pic != null &&
                    controller.song.value.pic.isNotEmpty)
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('${controller.song.value.pic}'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  )
                else
                  SizedBox(),
                if (controller?.loading?.value)
                  Container(
                    width: 40,
                    height: 40,
                    color: Colors.black45,
                    child: CupertinoActivityIndicator(),
                  )
                else
                  SizedBox(),
              ],
            ),
          )),
    );
  }
}

class BuildBottomSheet extends GetView<PlayerService> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 120), () {
      scrollController.jumpTo(
        (40 * controller.currIndex.value).toDouble(),
      );
    });
    return Obx(() {
      var widgets = <Widget>[];
      for (int i = 0; i < controller.playList?.length ?? 0; i++) {
        var song = controller.playList[i];
        widgets.add(_buildSongItem(song, () {
          controller.jumpToForIndex(i);
        }));
      }
      return Container(
        alignment: Alignment.center,
        child: FractionallySizedBox(
          widthFactor: 0.9,
          heightFactor: 0.95,
          child: PhysicalModel(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Get.theme.primaryColor,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide())),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => controller.changeMode(),
                          child: Row(
                            children: [
                              Icon(controller.modeIcon),
                              SizedBox(
                                width: 15,
                              ),
                              Text("${controller.modeText}")
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              child: Icon(Icons.delete),
                              onTap: () {
                                Get.defaultDialog(
                                    title: "",
                                    content: Text("确认删除所有吗?"),
                                    onConfirm: () {
                                      controller.playInit();
                                      controller.playList.value = [];
                                      Get.back();
                                      Get.back();
                                    });
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView(
                          controller: scrollController, children: widgets))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSongItem(Song song, VoidCallback callback) {
    bool flag = song.rid == controller.song.value?.rid;
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Get.theme.hintColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                        child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                          text: "${song.name}",
                          style: TextStyle(
                              fontSize: 13,
                              color: flag
                                  ? Get.theme.highlightColor
                                  : Colors.white),
                        ),
                        TextSpan(
                          text: " - ${song.artist}",
                          style: TextStyle(
                              fontSize: 10,
                              color: flag
                                  ? Get.theme.highlightColor
                                  : Get.theme.hoverColor),
                        )
                      ]),
                    )),
                    SizedBox(
                      width: 4,
                    ),
                    flag ? Loading() : SizedBox()
                  ],
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                height: 40,
                width: 40,
                color: Colors.transparent,
                child: Icon(
                  Icons.close,
                  size: 14,
                ),
              ),
              onTap: () {
                //删除列表里一首歌
                controller.deleteSongToPlayList(song);
              },
            )
          ],
        ),
      ),
    );
  }
}
