import 'package:flutter/material.dart';
import 'package:flutter_make_music/services/global_state.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:flutter_make_music/utils/theme.dart';
import 'package:get/get.dart';

class Mine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<GlobalState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("MINE"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: Constants.barHeight),
        itemBuilder: (content, index) {
          return ListTile(
            onTap: () {},
            title: Text("$index"),
          );
        },
        itemCount: 20,
      ),
    );
  }
}
