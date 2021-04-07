// 搜索框
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchInput extends StatelessWidget {
  final String title;
  final bool enabled;

  final ValueChanged onChange;
  final TextEditingController controller;
  final ValueChanged<bool> onFocus;

  final FocusNode _focusNode = FocusNode();

  SearchInput(
      {this.title,
      this.enabled = false,
      this.onChange,
      this.controller,
      this.onFocus}) {
    _focusNode.addListener(() => onFocus(_focusNode.hasFocus));
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              Get.toNamed('/Search');
            },
            child: Container(
              height: 35,
              child: TextField(
                focusNode: _focusNode,
                controller: controller,
                onChanged: onChange,
                enabled: enabled,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  fillColor: Get.theme.secondaryHeaderColor,
                  filled: true,
                  hintText: '$title',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x00000000)),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x00000000)),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x00000000)),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x00000000)),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                ),
              ),
            )));
  }
}
