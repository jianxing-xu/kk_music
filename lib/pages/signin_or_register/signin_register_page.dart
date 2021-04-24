import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:flutter_make_music/services/user.service.dart';
import 'package:get/get.dart';

enum InType { login, register }

class RegsiterOrSignin extends StatelessWidget {
  final type = InType.login.obs;
  final _fromKey = GlobalKey<FormState>();
  final username = ''.obs;
  final password = ''.obs;
  final loading = false.obs;

  final userService = Get.find<UserService>();

  @override
  Widget build(BuildContext context) {
    type(Get.arguments['type']);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: Get.width,
          child: Column(
            children: [
              _buildBar(),
              SizedBox(
                height: 30,
              ),
              _buildTitle(),
              SizedBox(
                height: 10,
              ),
              _buildForm(),
              Expanded(
                child: SizedBox(),
              ),
              _buildProtocol(),
            ],
          ),
        ),
      ),
    );
  }

  _buildBar() {
    return Container(
      alignment: Alignment.centerLeft,
      width: Get.width,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          child: Icon(
            Icons.close,
            size: 32,
          ),
        ),
      ),
    );
  }

  _buildTitle() {
    return Container(
      width: Get.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(type.value == InType.login ? "登录" : "注册",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.hoverColor))),
        ],
      ),
    );
  }

  final controller = TextEditingController();
  final controller2 = TextEditingController();
  _buildForm() {
    return Container(
      child: Form(
          key: _fromKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(hintText: '输入账号'),
                onSaved: (value) {
                  username(value);
                },
                validator: (String value) {
                  return value.trim().length >= 6 ? null : '账号最少6个字符';
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: controller2,
                obscureText: true,
                decoration: InputDecoration(hintText: '输入密码'),
                onSaved: (value) {
                  password(value);
                },
                validator: (String value) {
                  return value.trim().length >= 6 ? null : '密码最少6个字符';
                },
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () async {
                  if (loading.value) return;
                  var _state = _fromKey.currentState;
                  if (_state.validate()) {
                    _state.save();
                    loading(true);
                    if (type.value == InType.login) {
                      String msg = await userService.login(
                          username.value, password.value);
                      if (msg == "success") {
                        Get.back();
                      } else {
                        Get.snackbar("提示", "$msg");
                      }
                      loading(false);
                    } else {
                      bool flag = await userService.register(
                          username.value, password.value);
                      if (flag) {
                        Get.snackbar("提示", "注册成功");
                        type.value = InType.login;
                      } else {
                        Get.snackbar("提示", "注册失败");
                      }
                      loading(false);
                    }
                  }
                },
                child: Obx(() => AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      width: loading.value ? 45 : Get.width,
                      height: 45,
                      alignment: Alignment.center,
                      curve: Curves.ease,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: loading.value
                              ? Get.theme.hintColor
                              : Get.theme.highlightColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Obx(() => loading.value
                          ? CupertinoActivityIndicator()
                          : Text(
                              type.value == InType.login ? "登录" : "注册",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  type(type.value == InType.login
                      ? InType.register
                      : InType.login);
                  username("");
                  password("");
                  controller.clear();
                  controller2.clear();
                },
                child: Container(
                  child: Obx(() => Text(
                        type.value == InType.login ? "没有账号？去注册" : "已有账号？去登录",
                        style: TextStyle(fontSize: 16),
                      )),
                ),
              )
            ],
          )),
    );
  }

  _buildProtocol() {
    return Container();
  }
}
