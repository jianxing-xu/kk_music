import 'package:flutter/material.dart';
import 'package:flutter_make_music/utils/constants.dart';
import 'package:get/get.dart';

typedef MyTap = void Function(int);

class XNavigationBar extends StatefulWidget {
  final int initIndex = 0;
  final int currentIndex;
  final MyTap onTap;

  XNavigationBar({this.currentIndex, this.onTap});

  @override
  _XNavigationBarState createState() => _XNavigationBarState();
}

class _XNavigationBarState extends State<XNavigationBar> {
  int currentIndex = 0;
  MyTap onTap;

  @override
  void initState() {
    currentIndex = widget.initIndex;
    onTap = widget.onTap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.bottomBarHeight,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Item(currentIndex, Icons.home, "首页", currentIndex == 0, (i) {
            currentIndex = 0;
            setState(() {});
            onTap(0);
          }),
          Item(currentIndex, Icons.person, "我的", currentIndex == 1, (i) {
            currentIndex = 1;
            setState(() {});
            onTap(1);
          })
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  final int currentIndex;
  final IconData icon;
  final String label;
  final bool isActive;
  final MyTap onTap;

  Item(this.currentIndex, this.icon, this.label, this.isActive, this.onTap);

  @override
  Widget build(BuildContext context) {
    var color = isActive ? Get.theme.highlightColor : Colors.grey;
    return Expanded(
        child: GestureDetector(
      onTap: () => onTap(currentIndex),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: color,
            ),
            Text(
              label,
              style: TextStyle(
                  decoration: TextDecoration.none, fontSize: 10, color: color),
            ),
          ],
        ),
      ),
    ));
  }
}
