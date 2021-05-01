// 构建歌单卡片
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/model/home_model.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:get/get.dart';

class PlayListCardWidget extends StatelessWidget {
  final HPlayListItem playListItem;

  PlayListCardWidget({this.playListItem});

  @override
  Widget build(BuildContext context) {
    String countPlay =
        (double.parse(playListItem.countPlay) / 10000).toStringAsFixed(1);
    return GestureDetector(
      onTap: () {
        // 跳转到歌单详情
        Get.toNamed(Routes.PlayListDetail, arguments: {'id': playListItem.id});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        // width: (Get.width - Constants.pagePadding * 2) / 3 - 10,
        child: Column(
          children: [
            // 歌单卡片图片
            PhysicalModel(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Container(
                    // width: 100,
                    // height: 100,
                    child: FadeInImage(
                      image: NetworkImage("${playListItem.pic}"),
                      fit: BoxFit.cover,
                      placeholder: AssetImage("assets/images/bg.jpg"),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor.withOpacity(0.7),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10))),
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              size: 14,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text("${countPlay}w")
                          ],
                        ),
                      ))
                ],
              ),
            ),
            // 歌单卡片文字
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "${playListItem.name}",
                style: Get.theme.primaryTextTheme.bodyText2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
