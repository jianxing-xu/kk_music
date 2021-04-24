import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:get/get.dart';
import 'package:flutter_make_music/api/dio_client.dart';
import 'package:flutter_make_music/model/pixelbay.dart';
import 'package:flutter_make_music/utils/extension/get_extension.dart';

class ApiTestController extends GetxController {
  String content = "hello";
  DioClient client = Get.find();
  fetchData() async {
    Get.loading();
    try {
      await Future.delayed(Duration(seconds: 1));
      var appRes = await client.request("https://api.pexels.com/v1/search",
          queryParameters: {'query': 'cat', 'per_page': 3});
      if (appRes.ok) {
        var data = Pixelbay.fromJson(appRes.data);
        content = jsonEncode(data);
        update();
      } else {
        appRes.error.printError();
      }
      Get.dismiss();
    } catch (e) {
      print(e);
      Get.dismiss();
      Get.snackbar("网络错误", "",
          backgroundColor: Colors.black45,
          animationDuration: Duration(milliseconds: 500));
    }
  }
}

class ApiTest extends StatelessWidget {
  final controller = Get.put(ApiTestController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  controller.fetchData();
                },
                child: Text("fetchData".tr)),
            GetBuilder<ApiTestController>(
                builder: (_) => Text(
                      controller.content,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 20,
                    ))
          ],
        ),
      ),
    );
  }
}
