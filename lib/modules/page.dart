import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:get/get.dart';

class ModuleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(5),
        child: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: [
            _buildItem(Icons.router, "routingExample".tr, "/RouteExample"),
            _buildItem(Icons.message, "stateManagement".tr, "/StateManage"),
            _buildItem(
                Icons.language, "globalization".tr, "/TranslationExample"),
            _buildItem(Icons.color_lens, "theme".tr, "/ThemeExample"),
            _buildItem(
                Icons.network_check_sharp, "interfaceTest".tr, "/ApiTest"),
            _buildItem(Icons.settings_input_component, "componentTest".tr,
                "/ComponentTest"),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData iconData, String title, String url) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(url);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 40,
            ),
            SizedBox(
              height: 10,
            ),
            Text(title)
          ],
        ),
      ),
    );
  }
}
