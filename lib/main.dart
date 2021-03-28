import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/pages/home/bindings.dart';
import 'package:flutter_make_music/pages/mine/mine_page.dart';
import 'package:flutter_make_music/services/global_state.dart';
import 'package:flutter_make_music/utils/theme.dart';
import 'package:flutter_make_music/widget/bottom_bar//bottom_player_and_navgator_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_make_music/pages/home/home_page.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:flutter_make_music/lang/translation_service.dart';
import 'package:flutter_make_music/utils/dependencyInjection.dart';

/// TODO: 主题混乱问题未解决！！！！！！！！！！！！
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init service
  await DependencyInjection.init();
  //

  // run app
  runApp(MyApp());

  await Provider.refreshCookie();
}

// 全局使用，隐藏键盘
hideKeyBoard(BuildContext context) {
  FocusScopeNode focus = FocusScope.of(context);
  if (focus.hasPrimaryFocus && focus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var globalState = Get.find<GlobalState>();
    return GetMaterialApp(
        theme: XTheme.xDark(),
        translations: TranslationService(),
        locale: TranslationService.locale,
        fallbackLocale: TranslationService.fallbackLocale,
        defaultTransition: Transition.cupertino,
        initialRoute: AppPage.INITIAL,
        getPages: AppPage.routes,
        initialBinding: HomeBindings(),
        // 路由变化时回调
        routingCallback: (route) {
          print("ROUTE: ${route.current}");
          globalState.isOpenBottomSheet.value = route.isBottomSheet;
          globalState.currentRoutePath.value = route.current;
        },
        builder: (context, child) => GestureDetector(
            onTap: () => hideKeyBoard(context),
            child: Stack(
              children: [child, GlobalPlayer()],
            )),
        home: NavIndexView());
  }
}

// 层叠Stack页面 用于首页tab切换
class NavIndexView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalState globalState = Get.find();
    return Obx(() {
      return IndexedStack(
        index: globalState.index.value,
        children: [Home(), Mine()],
      );
    });
  }
}
