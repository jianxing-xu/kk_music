// 搜索框
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchInput extends StatelessWidget {
  final String title;
  final bool enabled;

  final ValueChanged<String> onChange;
  final TextEditingController controller;
  final ValueChanged<bool> onFocus;
  final VoidCallback tapSuffix;

  final FocusNode _focusNode = FocusNode();

  final iconData = Icons.search.obs;

  SearchInput(
      {this.title,
      this.enabled = false,
      this.onChange,
      this.controller,
      this.tapSuffix,
      this.onFocus}) {
    _focusNode.addListener(() => onFocus(_focusNode.hasFocus));
    controller.addListener(() {
      if (onChange != null) {
        onChange(controller.text);
      }
      setSuffixIcon(controller.text.isNotEmpty ? Icons.clear : Icons.search);
    });
  }

  setSuffixIcon(IconData icon) {
    iconData.value = icon;
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
                // onChanged: (v) {},
                enabled: enabled,
                decoration: InputDecoration(
                  suffixIcon: Obx(() => InkWell(
                        onTap: () {
                          if (iconData.value == Icons.clear) {
                            controller.text = "";
                          }
                          tapSuffix();
                        },
                        child: Icon(iconData.value),
                      )),
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
