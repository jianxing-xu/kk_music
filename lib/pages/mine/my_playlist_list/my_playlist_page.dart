import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/user.dart';
import 'package:flutter_make_music/model/user.dart';
import 'package:flutter_make_music/pages/mine/my_playlist_detail/my_playlist_detail.dart';
import 'package:flutter_make_music/services/user.service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_make_music/utils/extension/get_extension.dart';

class MyPlaylistPage extends StatelessWidget {
  final playlistName = "".obs;
  final isEdit = false.obs;
  final userService = Get.find<UserService>();
  final selected = <MyPlaylist>[].obs;

  removeSelected() {
    final ids = selected.map((e) => e.id);
    final idsStr = ids.join(",");
    Get.loading();
    UserApi.removeMulPlaylist(idsStr).then((res) {
      userService.user.update((val) {
        if (res.ok) {
          val.playList.removeWhere((v) => ids.contains(v.id));
          Fluttertoast.showToast(msg: "删除成功！");
        } else {
          Fluttertoast.showToast(msg: "删除失败！");
        }
        Get.dismiss();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的歌单"),
      ),
      body: Obx(() {
        final list = userService.user.value?.playList;
        final rowChildren = <Widget>[
          Text("${list.length}张歌单"),
          Expanded(child: SizedBox()),
        ];
        final List<Widget> widgets = [
          Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: rowChildren,
            ),
          ),
        ];
        if (isEdit.value) {
          rowChildren.addAll([
            selected.length != 0
                ? GestureDetector(
                    child: Text("删除"),
                    onTap: () => removeSelected(),
                  )
                : SizedBox(),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () => isEdit.toggle(),
              child: Text("完成"),
            )
          ]);
        } else {
          rowChildren.addAll([
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                    title: "新建歌单",
                    onConfirm: () {
                      if (playlistName.trim().isEmpty) return;
                      UserApi.createPlaylist(playlistName.value).then((res) {
                        if (res.ok) {
                          final playlist = MyPlaylist.fromJson(res.data);
                          userService.user.update((val) {
                            val.playList.add(playlist);
                          });
                          Get.back();
                        } else {
                          Fluttertoast.showToast(msg: "${res.error.msg}");
                        }
                      });
                    },
                    onCancel: () {},
                    content: Column(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.6,
                          child: TextField(
                            onChanged: (v) => playlistName.value = v,
                            decoration: InputDecoration(
                              hintText: "歌单名",
                              hintStyle: TextStyle(color: Get.theme.hoverColor),
                            ),
                          ),
                        )
                      ],
                    ));
              },
              child: Icon(
                Icons.add_box_sharp,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                isEdit.toggle();
              },
              child: Icon(Icons.view_list_rounded),
            )
          ]);
        }
        list.forEach((item) {
          widgets.add(_buildCard(item));
        });
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 8),
          children: widgets,
        );
      }),
    );
  }

  _buildCard(MyPlaylist playlist) {
    final index = selected.indexWhere((v) => v.id == playlist.id);
    final checked = index != -1;
    return ListTile(
      onTap: () {
        Get.to(() => MyPlaylistDetailPage(), arguments: {'id': playlist.id});
      },
      contentPadding: EdgeInsets.zero,
      title: Text(
        "${playlist.name}",
        overflow: TextOverflow.ellipsis,
      ),
      subtitle:
          Text("${playlist.totalCount} 首歌", overflow: TextOverflow.ellipsis),
      trailing: Icon(Icons.arrow_forward_ios),
      leading: isEdit.value
          ? Checkbox(
              value: checked,
              onChanged: (bool b) {
                if (checked) {
                  selected.removeAt(index);
                } else {
                  selected.add(playlist);
                }
              })
          : CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "assets/images/album.png",
              ),
            ),
    );
  }
}
