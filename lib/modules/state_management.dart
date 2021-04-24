import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class StateController extends GetxController {
  final name = 'jackson'.obs;
  final age = 10.obs;

  int buildCount = 0;

  buildIncreemnt() {
    buildCount++;
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class StateManagement extends StatelessWidget {
  final stateCtrl = Get.put<StateController>(StateController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${stateCtrl.name}"),
            spaceing,
            Obx(
              () => Text("${stateCtrl.age}"),
            ),
            GetX<StateController>(
              init: StateController(),
              builder: (controller) => Text("${controller.age}"),
            ),
            spaceing,
            ElevatedButton(
                onPressed: () {
                  stateCtrl.age.value++;
                },
                child: Text("age++")),
            spaceing,
            GetBuilder<StateController>(
              builder: (_) {
                print("age: ${_.age}, buildCount: ${_.buildCount}");
                return Text("${_.buildCount}");
              },
              init: StateController(),
            ),
            spaceing,
            ElevatedButton(
                onPressed: () {
                  stateCtrl.buildIncreemnt();
                },
                child: Text("GetBuildCount++"))
          ],
        ),
      ),
    );
  }

  Widget get spaceing => SizedBox(
        height: 10,
      );
}
