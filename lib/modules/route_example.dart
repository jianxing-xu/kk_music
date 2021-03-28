import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class User {
  int id;
  User(this.id);
  @override
  String toString() {
    return "User { id = $id}";
  }
}

class RouteExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("HomePage"),
            // 路径query方式
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/B?id=10');
              },
              child: Text("To B Page"),
            ),
            // 普通 arguments 方式, 可以传任何对象
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/C', arguments: {'user': User(999)});
              },
              child: Text("To C Page"),
            ),
            // 显示parameter参数和arguments差不多，只是健值都是字符串
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/D', parameters: {'id': '200'});
              },
              child: Text("To D Page"),
            ),
            // 和前端一样传参数
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/E/9999');
              },
              child: Text("To E Page"),
            )
          ],
        ),
      ),
    );
  }
}

class E extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(Get.parameters);
    return Scaffold(
      body: Center(
        child: Text("E Page id is ${Get.parameters['id']} "),
      ),
    );
  }
}

class D extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(Get.parameters);
    return Scaffold(
      body: Center(
        child: Text("D Page id is ${Get.parameters['id']} "),
      ),
    );
  }
}

class C extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(Get.arguments);
    User user = Get.arguments['user'] as User;
    return Scaffold(
      body: Center(
        child: Text("C Page userid is ${user.id}"),
      ),
    );
  }
}

class B extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(Get.parameters);
    // 简单响应式数据
    var count = 0.obs;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("B Page"),
            ElevatedButton(
              onPressed: () => Get.back(closeOverlays: true),
              child: Text("Back to Home"),
            ),
            ElevatedButton(
              onPressed: () => ++count,
              child: Obx(() => Text("Click $count")),
            ),
            ElevatedButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: "Hello Word !",
                      barrierDismissible: false,
                      onWillPop: () async {
                        print("you click backButton");
                        return true;
                      });
                },
                child: Text("Show Dialog!")),
            ElevatedButton(
                onPressed: () {
                  Get.snackbar("GetX SnakeBar", "Make show",
                      icon: Icon(Icons.favorite),
                      animationDuration: Duration(milliseconds: 500));
                },
                child: Text("Show SnakeBar!")),
            ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                      Container(
                        width: Get.size.width,
                        color: Colors.white,
                        height: 200,
                        child: Column(
                          children: [
                            Icon(Icons.line_style),
                            Expanded(
                              child: ListView(
                                children: [
                                  Text("Onw"),
                                  Text("Lisa"),
                                  Text("Jack")
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      enableDrag: true);
                },
                child: Text("Show BottomSheet!")),
          ],
        ),
      ),
    );
  }
}
