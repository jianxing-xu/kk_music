import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/utils/utils.dart';
import 'package:get/get.dart';

class Player extends StatelessWidget {
  final service = Get.find<PlayerService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${service?.song?.value?.name ?? '--'}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Get.theme.textTheme.bodyText1),
                Text(
                  "${service?.song?.value?.artist ?? '--'}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Get.theme.hoverColor),
                )
              ],
            ),
            centerTitle: true,
          ),
          body: Container(
            width: Get.width,
            child: Column(
              children: [
                // 大图
                Card(
                  shadowColor: Get.theme.primaryColor,
                  elevation: 10,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: Get.width * 0.8,
                    height: Get.width * 0.8,
                    child: Image.network("${service?.song?.value?.pic ?? ""}"),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/placeholder.png"),
                            fit: BoxFit.fill)),
                  ),
                ),
                // 简单歌词
                Container(
                    padding: EdgeInsets.only(top: 15),
                    width: Get.width * 0.8,
                    child: Column(
                      children: [
                        Text("${service.currentLyricStr}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20)),
                        Text("${service.nextLyricStr}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Get.theme.hoverColor))
                      ],
                    )),
                // 播放进度条
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: Get.width * 0.8,
                  child: CupertinoSlider(
                    value: service.percent.value,
                    activeColor: Get.theme.highlightColor,
                    onChangeStart: (v) {
                      service.isTouch = true;
                    },
                    onChangeEnd: (v) {
                      service.isTouch = false;
                      service.seekTime((service.totalTime * v).toInt());
                    },
                    onChanged: (v) {
                      if (service.song.value == null) return;
                      service.percent.value = v;
                    },
                  ),
                ),
                Container(
                  width: Get.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Utils.formatTime(service.currentTime.value.toDouble())}",
                        style: TextStyle(
                            fontSize: 12, color: Get.theme.hoverColor),
                      ),
                      Text(
                        "${Utils.formatTime(service.totalTime.value)}",
                        style: TextStyle(
                            fontSize: 12, color: Get.theme.hoverColor),
                      ),
                    ],
                  ),
                ),
                // 播放控制
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: Get.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => service.previous(),
                        child: Icon(Icons.fast_rewind, size: 50),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          service.playing.value
                              ? service.pause()
                              : service.play();
                        },
                        child: Icon(
                          service.playing.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 50,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () => service.next(),
                        child: Icon(
                          Icons.fast_forward,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
                // 模式 收藏 评论
                Container(
                  width: Get.width * 0.8,
                  margin: EdgeInsets.only(top: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: Container(
                          color: Colors.transparent,
                          child: Icon(service.modeIcon),
                        ),
                        onTap: () => service.changeMode(),
                      ),
                      GestureDetector(
                        child: Icon(Icons.favorite),
                      ),
                      GestureDetector(
                        child: Icon(Icons.comment),
                      ),
                    ],
                  ),
                ),
                // 按钮列表
              ],
            ),
          ),
        ));
  }
}
