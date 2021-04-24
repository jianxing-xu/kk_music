import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../home_controller.dart';

class TabView2 extends GetView<HomeController> {
  const TabView2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.symmetric(horizontal: 5),
      crossAxisCount: 2,
      children: [
        _buildItem(Icons.queue_music, "歌手", () => Get.toNamed(Routes.Singer)),
        _buildItem(Icons.music_video, "最新mv", () => Get.toNamed(Routes.Mv))
      ],
    );
  }

  Widget _buildItem(IconData icon, String title, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Card(
        margin: EdgeInsets.all(5),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              SizedBox(
                height: 10,
              ),
              Text("$title")
            ],
          ),
        ),
      ),
    );
  }
}
