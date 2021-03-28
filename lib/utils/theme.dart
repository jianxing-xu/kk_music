import 'package:flutter/material.dart';

class XTheme {
  static ThemeData xDark() => ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff1a1a1a), // 主色调
        secondaryHeaderColor: Color(0xff202124),
        highlightColor: Color(0xff73eab6), // 高亮色调主题色
        backgroundColor: Color(0xff000000), // 一些卡片的背景
        hintColor: Color(0xff3c3c3c), // 输入框等，提示颜色
        hoverColor: Color(0xffcccccc), // 次级字体颜色
        scaffoldBackgroundColor: Color(0xff1a1a1a),
        primaryTextTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 14, color: Color(0xfffffff0)),
          bodyText2: TextStyle(fontSize: 12, color: Color(0xfffffff0)),
        ),
      );

  static ThemeData xNormal() => ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xfff9fafb),
      scaffoldBackgroundColor: Color(0xfff9fafb),
      secondaryHeaderColor: Color(0xff202124),
      highlightColor: Color(0xff73eab6),
      backgroundColor: Color(0xffffffff),
      hintColor: Color(0xff3c3c3c),
      hoverColor: Color(0xff333333),
      primaryTextTheme: TextTheme(
        bodyText1: TextStyle(fontSize: 14, color: Color(0xff666666)),
      ));
}
