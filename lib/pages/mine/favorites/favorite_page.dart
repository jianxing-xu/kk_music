import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/user.dart';
import 'package:flutter_make_music/pages/add_to_collection/add_to_collection_page.dart';
import 'package:flutter_make_music/pages/mine/favorites/favorite_controller.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:flutter_make_music/widget/base/loading.dart';
import 'package:flutter_make_music/widget/refresh_header.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoritesPage extends StatelessWidget {
  final controller = Get.put(FavoriteController());
  final playService = Get.find<PlayerService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("我喜欢"),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(() => AddToCollectionPage(
                      action: (songs) async {
                        final ids =
                            songs?.map((e) => e.rid)?.toList()?.join(",") ?? "";
                        final addToDB = UserApi.addMulSongToDB(songs);
                        final addToFavorite = UserApi.favoriteMulSong(ids);
                        return Future.wait([addToDB, addToFavorite])
                            .then((list) {
                          if ((list[0].ok && list[1].ok)) {
                            controller.userService.user.update((user) {
                              final s = Set();
                              s.addAll(user.favorites.split(","));
                              s.addAll(ids.split(","));
                              user.favorites = s.toList().join(",");
                            });
                            return true;
                          } else {
                            return Future.error(false);
                          }
                        });
                      },
                    ));
              },
              child: Icon(Icons.add),
            )
          ],
        ),
        body: Obx(() {
          final songs = controller.songs.value;
          return FutureBuilder(
            future: controller.future.value,
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
                    controller: controller.refreshController,
                    onRefresh: () => controller.loadData(true),
                    header: refreshHeader,
                    child: ListView(
                      children: List.generate(songs.length + 1, (index) {
                        if (index == songs.length) {
                          return SizedBox(
                            height: Constants.miniPlayerHeight,
                          );
                        }
                        final song = songs[index];

                        return Slidable(
                            key: Key(song.rid.toString()),
                            child: Container(
                              color: Get.theme.primaryColor,
                              child: ListTile(
                                key: Key(song.rid.toString()),
                                onTap: () {
                                  playService.setPlayList(songs);
                                  playService.setCurrentIndex(index);
                                },
                                leading: Text("${index + 1}"),
                                title: Text(
                                  "${song.name}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  "${song.artist}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: '取消收藏',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  controller.cancelFavorite(index, song.rid);
                                },
                              ),
                            ],
                            actionPane: SlidableBehindActionPane());
                      }),
                    ),
                  );
                }
              } else {
                widget = Center(
                  child: Loading(),
                );
              }
              return widget;
            },
          );
        }));
  }
}
