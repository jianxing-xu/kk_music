import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Hello !"),
            SizedBox(
              height: 10,
            ),
            Text("你好"),
            ElevatedButton(
                onPressed: () {
                  Get.changeTheme(
                      Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
                },
                child: Text("改变主题")),
          ],
        ),
      ),
    );
  }
}
