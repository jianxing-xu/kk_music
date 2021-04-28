import 'package:flutter/material.dart';
import 'package:flutter_make_music/pages/signin_or_register/signin_register_page.dart';
import 'package:flutter_make_music/services/user.service.dart';
import 'package:get/get.dart';

class AuthPage extends StatelessWidget {
  final userService = Get.find<UserService>();
  final Widget child;
  AuthPage({this.child});
  @override
  Widget build(BuildContext context) {
    if (userService.isLogin.value) {
      return child;
    } else {
      return RegsiterOrSignin();
    }
  }
}
