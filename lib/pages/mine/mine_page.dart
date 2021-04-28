import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/user.dart';
import 'package:flutter_make_music/model/user.dart';
import 'package:flutter_make_music/pages/mine/edit_info/edit_info_page.dart';
import 'package:flutter_make_music/pages/mine/favorites/favorite_page.dart';
import 'package:flutter_make_music/pages/signin_or_register/signin_register_page.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:flutter_make_music/services/global_state.dart';
import 'package:flutter_make_music/services/user.service.dart';
import 'package:flutter_make_music/widget/auth_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_make_music/utils/extension/get_extension.dart';

class Mine extends StatelessWidget {
  final controller = Get.find<GlobalState>();
  final userService = Get.find<UserService>();
  final playlistName = "".obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的"),
        centerTitle: false,
      ),
      body: Obx(() {
        final user = userService.user.value;
        return ListView(
          children: [
            _buildInfoCard(user),
            SizedBox(
              height: 10,
            ),
            _buildButtons(user),
            SizedBox(
              height: 10,
            ),
            _buildPlaylist(user?.playList ?? []),
            SizedBox(
              height: 10,
            ),
            _buildPlaylistRow(user?.playList ?? [])
          ],
        );
      }),
    );
  }

  _buildInfoCard(User user) {
    final avatarImg = user?.avatar == null
        ? AssetImage("assets/images/album.png")
        : NetworkImage(user.avatar);
    String username = user?.username ?? "";
    Widget title = userService.isLogin.value
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "一共听了${user.listenCount}首歌了！",
                style: TextStyle(fontSize: 10, color: Get.theme.highlightColor),
              )
            ],
          )
        : GestureDetector(
            onTap: () => Get.toNamed(Routes.RegisterOrSignin,
                arguments: {'type': InType.login}),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              color: Colors.transparent,
              child: Text("登录"),
            ),
          );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Get.theme.backgroundColor),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Get.theme.primaryColor,
                backgroundImage: avatarImg,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: title,
                flex: 2,
              ),
              Expanded(child: SizedBox()),
              InkWell(
                onTap: () {
                  if (!userService.isLogin.value) {
                    return Get.toNamed(Routes.RegisterOrSignin,
                        arguments: {'type': InType.login});
                  }
                  Get.to(EditInfoPage());
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.transparent,
                  child: Icon(Icons.edit_road),
                ),
              ),
              SizedBox(
                width: 5,
              )
            ],
          )
        ],
      ),
    );
  }

  _buildButtons(User user) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Get.theme.backgroundColor),
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(AuthPage(
                child: FavoritesPage(),
              ));
            },
            child: Column(
              children: [
                Icon(
                  Icons.favorite,
                  color: Get.theme.highlightColor,
                  size: 25,
                ),
                Text("喜欢"),
                Text("${user?.favoriteCount ?? 0}")
              ],
            ),
          ),
          Column(
            children: [
              Icon(
                Icons.playlist_play_sharp,
                color: Get.theme.highlightColor,
                size: 25,
              ),
              Text("歌单"),
              Text("${user?.playlistCount ?? 0}")
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.play_arrow,
                color: Get.theme.highlightColor,
                size: 25,
              ),
              Text("最近听歌"),
              Text("${user?.recentPlayCount ?? 0}")
            ],
          )
        ],
      ),
    );
  }

  _buildPlaylist(List<MyPlaylist> playlist) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Get.theme.backgroundColor),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text("自建歌单 ${playlist?.length ?? 0}"),
          Expanded(child: SizedBox()),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("新建"),
                SizedBox(
                  width: 2,
                ),
                Icon(
                  Icons.add_box_sharp,
                  color: Get.theme.highlightColor,
                )
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Row(
            children: [
              Text("更多"),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 12,
                color: Get.theme.highlightColor,
              )
            ],
          )
        ],
      ),
    );
  }

  _buildPlaylistRow(List<MyPlaylist> playlist) {
    List<Widget> widgets = [];
    playlist?.forEach((element) {
      widgets.add(_buildSinglePlaylist(element));
      widgets.add(SizedBox(
        width: 4,
      ));
    });
    return Container(
      child: SingleChildScrollView(
        child: Row(
          children: widgets,
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  _buildSinglePlaylist(MyPlaylist playlist) {
    final pic = playlist?.pic != null && playlist?.pic.toString().isNotEmpty
        ? Image.network(
            playlist.pic,
            fit: BoxFit.contain,
          )
        : Image.asset(
            "assets/images/album.png",
            fit: BoxFit.contain,
          );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          height: 120,
          child: pic,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.theme.backgroundColor),
        ),
        SizedBox(
          height: 2,
        ),
        Text("${playlist.name}")
      ],
    );
  }
}
