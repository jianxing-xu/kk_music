import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/pages/playlist_detail/controller.dart';
import 'package:get/get.dart';

class PlayListDetail extends StatelessWidget {
  final controller = Get.put(PlayListDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, flag) {
          return <Widget>[
            SliverAppBar(
              title: Text("HELLOHELLOHELLO"),
              pinned: true,
              expandedHeight: 260,
              collapsedHeight: 60,
              backgroundColor: Colors.red,
              flexibleSpace: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: Container(
                  width: Get.width,
                  // height: 260,
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 0,
                          child: Container(
                            width: Get.width,
                            child: Image.network(
                              "https://img1.kuwo.cn/star/userpl2015/15/39/1618286708272_448007115_700.jpg",
                              fit: BoxFit.fill,
                            ),
                          )),
                      Positioned(
                          bottom: 0,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
                            child: Container(
                              width: Get.width,
                              height: 260,
                              color: Colors.transparent,
                            ),
                          )),
                      // TODO: 歌单头部
                      Positioned(
                          bottom: 0,
                          child: Container(
                            padding:
                                EdgeInsets.only(top: 50, left: 15, right: 15),
                            width: Get.width,
                            height: 260,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        child: Image.network(
                                          "https://img1.kuwo.cn/star/userpl2015/15/39/1618286708272_448007115_700.jpg",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      // 右侧信息
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Container(
                                            // 歌单名
                                            child: Text("抒情DJ | 我和你之间不剩一丝牵挂",
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
                                                backgroundImage: NetworkImage(
                                                    "https://img1.kuwo.cn/star/userhead/15/39/1586222053915_448007115.jpg"),
                                                maxRadius: 13,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                "腾讯音乐人",
                                                style: TextStyle(fontSize: 13),
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
                                              "简介：就这样吧，我和你最好的结果就是不在牵挂。",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Get.theme.hoverColor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.only(top: 28),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("播放全部"),
                                      Icon(Icons.play_arrow_rounded)
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            )
          ];
        },
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: List.generate(
          30,
          (index) => ListTile(
                title: Text("$index"),
              )).toList(),
    );
  }
}
