import 'package:flutter_make_music/modules/route_example.dart';
import 'package:flutter_make_music/modules/state_management.dart';
import 'package:flutter_make_music/modules/theme_example.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'api_test.dart';
import 'component_test.dart';
import 'translation.dart';

var routes = [
  GetPage(name: '/B', page: () => B()),
  GetPage(name: '/C', page: () => C()),
  GetPage(name: '/D', page: () => D()),
  GetPage(name: '/E/:id', page: () => E()),
  GetPage(name: '/RouteExample', page: () => RouteExample()),
  GetPage(name: '/StateManage', page: () => StateManagement()),
  GetPage(name: '/TranslationExample', page: () => Translation()),
  GetPage(name: '/ThemeExample', page: () => ThemeExample()),
  GetPage(name: '/ApiTest', page: () => ApiTest()),
  GetPage(name: '/ApiTest', page: () => ApiTest()),
  GetPage(name: '/ComponentTest', page: () => ComponentTest())
];
