import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/user.dart';
import 'package:flutter_make_music/services/user.service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:flutter_make_music/utils/extension/get_extension.dart';

class EditInfoPage extends StatelessWidget {
  final userService = Get.find<UserService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人资料"),
      ),
      body: Obx(() {
        final user = userService.user.value;
        final avatar = user?.avatar != null
            ? NetworkImage("${user.avatar}")
            : AssetImage("assets/images/album.png");
        return ListView(
          children: [
            ListTile(
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "敬请期待!", backgroundColor: Get.theme.hintColor);
                },
                leading: Text("头像"),
                trailing: Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundImage: avatar,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      )
                    ],
                  ),
                )),
            ListTile(
              onTap: () => Get.to(EditUsername(),
                  arguments: {'name': "${user?.username ?? ''}"}),
              leading: Text("昵称"),
              trailing: Container(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${user?.username ?? ''}"),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(EditPassword());
                },
                child: Text("修改密码")),
            ElevatedButton(
                onPressed: () {
                  userService.logout();
                  Get.back();
                },
                child: Text("退出登录"))
          ],
        );
      }),
    );
  }
}

class EditPassword extends StatelessWidget {
  final userService = Get.find<UserService>();
  final oldpwd = "".obs;
  final newpwd = "".obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("修改密码"),
      ),
      body: Center(
        child: Container(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) => oldpwd(value),
                decoration: InputDecoration(hintText: "旧密码"),
              ),
              TextField(
                onChanged: (value) => newpwd(value),
                decoration: InputDecoration(hintText: "新密码"),
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (newpwd.value.trim().isEmpty ||
                      oldpwd.value.trim().isEmpty) {
                    return Fluttertoast.showToast(msg: "不能为空");
                  }
                  if (newpwd.value.trim().length < 6) {
                    return Fluttertoast.showToast(msg: "长度不能低于6位");
                  }
                  Get.loading();
                  UserApi.updatePwd(oldpwd.value, newpwd.value).then((value) {
                    Get.dismiss();
                    Fluttertoast.showToast(msg: "修改成功");
                    Get.back();
                  });
                },
                child: Container(
                  height: 35,
                  width: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Get.theme.highlightColor),
                  child: Text(
                    "确认",
                    style: TextStyle(color: Get.theme.hintColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditUsername extends StatelessWidget {
  final userService = Get.find<UserService>();
  final username = "".obs;
  int get count => username?.value?.length ?? 0;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final name = Get.arguments['name'];
    controller.text = name;
    username(name);
    return Scaffold(
        appBar: AppBar(
          title: Text("设置昵称"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  maxLength: 15,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RawChip(
                onPressed: () {
                  String username = controller.text;
                  Get.loading();
                  userService.updateInfo(username).then((value) {
                    Get.dismiss();
                    userService.user.update((val) {
                      val.username = username;
                    });
                    Get.back();
                    Fluttertoast.showToast(
                        msg: "修改成功", backgroundColor: Get.theme.hintColor);
                  }).catchError((e) {
                    Get.dismiss();
                  });
                },
                padding: EdgeInsets.symmetric(horizontal: 80),
                label: Text("确定",
                    style: TextStyle(
                      color: Get.theme.hintColor,
                    )),
                backgroundColor: Get.theme.highlightColor,
              )
            ],
          ),
        ));
  }
}
