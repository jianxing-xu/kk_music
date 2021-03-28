import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComponentTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        buildFadeImage(),
      ],
    ));
  }

  buildFadeImage() {
    return Column(
      children: [
        Title(
          color: Colors.black,
          title: "图片占位组件",
          child: Text("图片占位组件"),
        ),
        FadeInImage(
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            placeholder: AssetImage('assets/images/img_loading.gif'),
            image: NetworkImage(
                'https://wx3.sinaimg.cn/mw690/002vu30Xly1goh72gjkc2j628g6pc4qt02.jpg')),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
