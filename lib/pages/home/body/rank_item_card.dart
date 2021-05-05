// 构建排行榜卡片
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/model/home_model.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';

class RankItemCardWidget extends StatelessWidget {
  final HRankItem rankItem;

  RankItemCardWidget({this.rankItem});

  @override
  Widget build(BuildContext context) {
    // debugPaintSizeEnabled = true;
    List<Widget> songList = [];
    songList.add(Container(
      padding: EdgeInsets.only(top: 8, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${rankItem.label}",
            style: TextStyle(fontSize: 14),
          ),
          Icon(
            Icons.chevron_right,
            size: 16,
          )
        ],
      ),
    ));
    for (int j = 0; j < rankItem.list.length; j++) {
      var song = rankItem.list[j];
      songList.add(Container(
        margin: EdgeInsets.only(bottom: j == rankItem.list.length ? 0 : 12),
        child: Text(
          "${j + 1}. ${song.name} - ${song.artistName}",
          style: TextStyle(fontSize: 10, color: Get.theme.hoverColor),
          overflow: TextOverflow.ellipsis,
        ),
      ));
    }
    /////
    return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.RankDetial,
              arguments: {'id': rankItem.typeId, 'label': rankItem.label});
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          height: 120,
          child: PhysicalModel(
              color: Get.theme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  //image
                  Container(
                    height: 120,
                    width: 120,
                    child: PhysicalModel(
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage(
                        placeholder: AssetImage("assets/images/bg.jpg"),
                        image: NetworkImage("${rankItem.picIcon}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //list
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: songList,
                    ),
                  ))
                ],
              )),
        ));
  }
}
