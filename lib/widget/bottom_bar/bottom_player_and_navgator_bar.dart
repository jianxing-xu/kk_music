import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_make_music/services/global_state.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:flutter_make_music/widget/bottom_bar//mini_player.dart';
import 'package:flutter_make_music/widget/bottom_bar//x_navigation_bar.dart';
import 'package:get/get.dart';

class GlobalPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var globalState = Get.find<GlobalState>();
    return Obx(() {
      return AnimatedPositioned(
          // 在主页面迷你播放器为
          bottom: globalState.themeHack.value
              ? globalState.miniPlayerOffset
              : globalState.miniPlayerOffset,
          duration: Duration(milliseconds: 600),
          width: Get.width,
          curve: Curves.ease,
          child: Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                      child: Opacity(
                        opacity: 0.8,
                        child: Container(
                          width: Get.width,
                          height: Constants.barHeight +
                              (GetPlatform.isAndroid ? 0 : 30),
                          color: Get.theme.primaryColor, // 主题修改延迟
                        ),
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: GetPlatform.isAndroid ? 0 : 30),
                child: Column(
                  children: [
                    MiniPlayer(),
                    XNavigationBar(
                      currentIndex: 0,
                      onTap: (i) {
                        globalState.change(i);
                      },
                    )
                  ],
                ),
              )
            ],
          ));
    });
  }
}
