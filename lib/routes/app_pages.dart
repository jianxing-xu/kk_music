import 'package:flutter_make_music/pages/home/home_page.dart';
import 'package:flutter_make_music/pages/mine/mine_page.dart';
import 'package:flutter_make_music/pages/mv/mv.dart';
import 'package:flutter_make_music/pages/mv/mv_detail/mv_detail_page.dart';
import 'package:flutter_make_music/pages/player/player_page.dart';
import 'package:flutter_make_music/pages/playlist/playlist_page.dart';
import 'package:flutter_make_music/pages/playlist_detail/playlist_detail_page.dart';
import 'package:flutter_make_music/pages/rank/rank_page.dart';
import 'package:flutter_make_music/pages/rank_detail/rank_detail_page.dart';
import 'package:flutter_make_music/pages/search/search_page.dart';
import 'package:flutter_make_music/pages/signin/sign_in_page.dart';
import 'package:flutter_make_music/pages/signout/sign_out_page.dart';
import 'package:flutter_make_music/pages/singers/singer_detail_page/singer_detail_page.dart';
import 'package:flutter_make_music/pages/singers/singers_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPage {
  static const INITIAL = Routes.HOME;
  static final routes = [
    GetPage(name: Routes.HOME, page: () => Home()),
    GetPage(name: Routes.Mine, page: () => Mine()),
    GetPage(name: Routes.Search, page: () => SearchPage()),
    GetPage(name: Routes.PlayListDetail, page: () => PlayListDetail()),
    GetPage(name: Routes.RankDetial, page: () => RankDetail()),
    GetPage(name: Routes.Rank, page: () => RankPage()),
    GetPage(name: Routes.PlayList, page: () => PlayListPage()),
    GetPage(name: Routes.Singer, page: () => SingersPage()),
    GetPage(name: Routes.SingerDetail, page: () => SingerDetailPage()),
    GetPage(name: Routes.Mv, page: () => MvPage()),
    GetPage(name: Routes.MvDetail, page: () => MvDetailPage()),
    GetPage(name: Routes.Player, page: () => Player()),
    GetPage(name: Routes.SignIn, page: () => SignIn()),
    GetPage(name: Routes.SignOut, page: () => SignOut()),
  ];
}
