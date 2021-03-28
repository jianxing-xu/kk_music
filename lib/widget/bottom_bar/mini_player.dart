import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_make_music/pages/player/player_page.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:get/get.dart';

class MiniPlayer extends GetView<PlayerService> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
          onTap: () {
            print("TOPALY");
            Get.to(Player(),transition: Transition.upToDown);
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
                            "${controller?.currSong?.name ?? ''} - ${controller?.currSong?.artist ?? ''}",
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
                            // TODO: 播放列表
                            Get.bottomSheet(_buildBottomSheet());
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.queue_music),
                          ),
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
                if (controller?.currSong?.pic != null)
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('${controller.currSong.pic}'),
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

  Widget _buildBottomSheet() {
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
          ),
        ),
      ),
    );
  }
}
