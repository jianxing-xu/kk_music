import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double h1 = 0;
  double h2 = 0;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
        animationBehavior: AnimationBehavior.preserve)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      })
      ..addListener(() {
        setState(() {
          h1 = _controller.value * 15;
          h2 = (1 - _controller.value) * 15;
        });
      });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 4,
            height: h1,
            color: Get.theme.highlightColor,
          ),
          SizedBox(
            width: 4,
          ),
          Container(
            width: 4,
            height: h2,
            color: Get.theme.highlightColor,
          ),
          SizedBox(
            width: 4,
          ),
          Container(
            width: 4,
            height: h1,
            color: Get.theme.highlightColor,
          ),
        ],
      ),
    );
  }
}
