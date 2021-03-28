import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/pages/playlist_detail/controller.dart';
import 'package:get/get.dart';

class PlayListDetail extends StatelessWidget {
  final controller = Get.put(PlayListDetailController());

  @override
  Widget build(BuildContext context) {
    String id = Get.arguments['id'];
    print("playlist id is : $id");
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Container(
        child: Center(
          child: Text("PlayListDetail id is : $id"),
        ),
      ),
    );
  }
}
