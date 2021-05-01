import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/user.dart';
import 'package:flutter_make_music/model/song.dart';
import 'package:flutter_make_music/model/user.dart';
import 'package:flutter_make_music/pages/add_to_collection/add_to_collection_page.dart';
import 'package:flutter_make_music/services/player_service.dart';
import 'package:flutter_make_music/services/user.service.dart';
import 'package:flutter_make_music/widget/base/loading.dart';
import 'package:flutter_make_music/widget/refresh_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_make_music/utils/extension/get_extension.dart';

class MyPlaylistController extends GetxController {
  int id;
  final userService = Get.find<UserService>();
  Rx<Future> future = Rx<Future>(Future.sync(() => null));
  Rx<MyPlaylist> playlist = Rx<MyPlaylist>(null);
  Rx<List<Song>> selected = Rx<List<Song>>([]);

  RefreshController refreshController = RefreshController();

  final isEdit = false.obs;

  loadData([bool refresh = false]) async {
    final pedding = UserApi.findPlaylistInfo(id).then((res) {
      if (res.ok) {
        final data = MyPlaylist.fromJson(res.data);
        playlist.value = data;
        refreshController.refreshCompleted();
        return data;
      } else {
        refreshController.refreshFailed();
        return Future.error(res.error.msg);
      }
    });
    if (!refresh) {
      future.value = pedding;
    }
  }

  removeSelected() {
    final ids = selected.value.map((e) => e.rid).join(",");
    Get.loading();
    UserApi.removeSongForPlaylist(id, ids).then((res) {
      if (res.ok) {
        playlist.update((val) {
          val.musicList
              .removeWhere((element) => ids.contains(element.rid.toString()));
        });
      }
      Fluttertoast.showToast(msg: res.ok ? "操作成功" : "操作失败").then((value) {
        Get.dismiss();
      });
    });
  }

  Future<bool> addToPlaylist(List<Song> list) async {
    final ids = list.map((e) => e.rid).join(",");
    final f1 = UserApi.addMulSongToDB(list);
    return f1.then((res) async {
      try {
        if (res.ok) {
          final res2 = await UserApi.addSongToPlaylist(id, ids);
          if (res.ok && res2.ok) {
            playlist.update((val) {
              val.musicList.addAll(list);
              final index = userService.user.value.playList
                  .indexWhere((element) => element.id == val.id);
              userService.user.update((val) {
                if (index != -1) {
                  val.playList[index].totalCount += list.length;
                }
              });
            });
            return res.ok && res2.ok;
          } else {
            return res.ok && res2.ok;
          }
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    });
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }

  @override
  void onInit() {
    print(Get.arguments);
    if (Get.arguments != null) {
      id = Get.arguments['id'];
    }
    super.onInit();
  }
}

class MyPlaylistDetailPage extends StatelessWidget {
  final controlelr = Get.put(MyPlaylistController());
  final player = Get.find<PlayerService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() => Text("${controlelr.playlist.value?.name ?? ''}")),
          actions: [
            Obx(() {
              final isEdit = controlelr.isEdit;
              var widgets = <Widget>[];
              if (isEdit.value) {
                widgets = [
                  controlelr.selected.value.length == 0
                      ? SizedBox()
                      : GestureDetector(
                          onTap: () => controlelr.removeSelected(),
                          child: Text("删除选中"),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      child: Text("完成"), onTap: () => isEdit.toggle())
                ];
              } else {
                widgets = [
                  GestureDetector(
                      child: Icon(Icons.settings),
                      onTap: () => isEdit.toggle()),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      child: Icon(Icons.add),
                      onTap: () {
                        Get.to(() => AddToCollectionPage(
                              action: (data) async {
                                return controlelr.addToPlaylist(data);
                              },
                            ));
                      })
                ];
              }
              return Row(children: widgets);
            })
          ],
        ),
        body: Obx(() {
          final data = controlelr.playlist.value;
          final selected = controlelr.selected.value;
          final isEdit = controlelr.isEdit;
          return FutureBuilder(
            future: controlelr.future.value,
            builder: (c, s) {
              Widget widget;
              if (s.connectionState == ConnectionState.done) {
                if (s.hasError) {
                  widget = Center(
                    child: ElevatedButton(
                      onPressed: () => controlelr.loadData(),
                      child: Text("点击重试"),
                    ),
                  );
                } else {
                  widget = SmartRefresher(
                    header: refreshHeader,
                    onRefresh: () => controlelr.loadData(true),
                    controller: controlelr.refreshController,
                    child: ListView(
                      children: [
                        Container(),
                        Container(
                          child: Column(
                            children: List.generate(data.musicList?.length ?? 0,
                                (index) {
                              final song = data.musicList[index];
                              return Obx(() => ListTile(
                                    onTap: () {
                                      if (controlelr.isEdit.value) return;
                                      player.setPlayList(data.musicList);
                                      player.setCurrentIndex(index);
                                    },
                                    minLeadingWidth: 0,
                                    leading: isEdit.value
                                        ? Checkbox(
                                            value: selected?.indexWhere(
                                                    (v) => v.rid == song.rid) !=
                                                -1,
                                            onChanged: (bool b) {
                                              final idx = selected.indexWhere(
                                                  (v) => v.rid == song.rid);
                                              controlelr.selected.update((val) {
                                                if (idx == -1) {
                                                  val.add(song);
                                                } else {
                                                  val.removeAt(idx);
                                                }
                                              });
                                            },
                                          )
                                        : SizedBox(),
                                    // minLeadingWidth: 0,
                                    title: Text("${song.name}"),
                                    subtitle: Text("${song.artist}"),
                                  ));
                            }),
                          ),
                        )
                      ],
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
