// 首页第一个tab
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/model/home_model.dart';
import 'package:flutter_make_music/pages/home/body/playlist_card.dart';
import 'package:flutter_make_music/pages/home/body/rank_item_card.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:flutter_make_music/widget/base/loading.dart';
import 'package:flutter_make_music/widget/refresh_header.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../home_controller.dart';

class TabView1 extends GetView<HomeController> {
  const TabView1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (HomeController c) {
          List<BannerItem> bannerList = c?.model?.bannerList;
          List<HPlayListItem> playList = c?.model?.playList;
          List<HRankItem> rankList = c?.model?.rankList;
          return FutureBuilder(
            future: c.homeFuture,
            builder: (context, snapshot) {
              Widget widget;
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  widget = Center(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.loadData();
                      },
                      child: Text("点击重试"),
                    ),
                  );
                } else {
                  widget = SmartRefresher(
                    header: refreshHeader,
                    controller: c.refreshController,
                    onRefresh: c.refreshData,
                    child: ListView(
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            height: 150,
                            child: _buildSwiper(bannerList)),
                        Container(
                          child: _buildPlayList(playList),
                        ),
                        Container(
                          child: _buildRank(rankList),
                        ),
                        SizedBox(
                          height: Constants.barHeight,
                        )
                      ],
                    ),
                  );
                }
              } else {
                return Container(
                  child: Loading(),
                );
              }
              return widget;
            },
          );
        });
  }

  // 头部
  Widget _buildTitle(String title, VoidCallback callback) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$title",
              style: Get.theme.textTheme.headline6,
            ),
            GestureDetector(
              onTap: callback,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("更多", style: Get.theme.textTheme.bodyText2),
                  SizedBox(
                    width: 0,
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 12,
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildSwiper(List<BannerItem> bannerList) {
    return Swiper(
      loop: true,
      autoplay: true,
      scale: 0.95,
      viewportFraction: 0.9,
      itemCount: bannerList?.length ?? 0,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    "${bannerList[index]?.pic}",
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        );
      },
    );
  }

  Widget _buildPlayList(List<HPlayListItem> playList) {
    if (playList == null) return null;
    List<Widget> items1 = [];
    List<Widget> items2 = [];
    for (int i = 0; i < playList.length; i++) {
      var item = playList[i];
      if (i <= 2) {
        items1.add(Container(
          width: (Get.width - Constants.pagePadding * 2) / 3 - 10,
          child: PlayListCardWidget(
            playListItem: item,
          ),
        ));
      } else {
        items2.add(Container(
          width: (Get.width - Constants.pagePadding * 2) / 3 - 10,
          child: PlayListCardWidget(
            playListItem: item,
          ),
        ));
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Constants.pagePadding),
      child: Column(
        children: [
          _buildTitle("推荐歌单", () {
            Get.toNamed(Routes.PlayList);
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items2,
          )
        ],
      ),
    );
  }

  Widget _buildRank(List<HRankItem> rankList) {
    List<Widget> items = [];
    items.add(_buildTitle("排行榜", () {
      Get.toNamed(Routes.Rank);
    }));
    if (rankList != null) {
      for (int i = 0; i < rankList.length; i++) {
        items.add(RankItemCardWidget(
          rankItem: rankList[i],
        ));
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Constants.pagePadding),
      child: Column(
        children: items,
      ),
    );
  }
}
