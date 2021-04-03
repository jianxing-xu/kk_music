import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/search_result.dart';
import 'package:flutter_make_music/model/song.dart';
import 'package:flutter_make_music/utils/pagin_state.dart';
import 'package:flutter_make_music/utils/utils.dart';
import 'package:get/get.dart';

class SearchController extends GetxController
    with SingleGetTickerProviderMixin {
  TabController tabController;
  TextEditingController searchController;
  EasyRefreshController easyController;
  PagingState pagingState = PagingState();
  final keyword = "".obs;
  final hotKeys = <String>[].obs;
  final searchKeys = <String>[].obs;

  final Rx<SearchResult> result = Rx<SearchResult>();

  final isResult = false.obs;

  int get indexed {
    if (isResult.value) return 2;
    if (keyword.value.isEmpty) return 0;
    return 1;
  }

  final error = false.obs;

  search({String type = "Music"}) async {
    error.value = false;
    // 点击搜索就跳转到搜索结果
    isResult.value = true;
    try {
      var res = await Provider.getSearchResult(
          keyword.value, type, pagingState.page, pagingState.pageNum);
      if (res.ok) {
        var data = SearchResult.fromJson(res.data);
        if (result.value == null) {
          pagingState.total = data.total;
          if (type == "Artist") {
            result.value = SearchResult(artistList: data.artistList);
          } else {
            result.value = data;
          }
        } else {
          if (type == "Music") {
            result.update((val) {
              var list = <Song>[];
              list..addAll(val.list)..addAll(data.list);
              val.list = list;
            });
          }
          if (type == "Artist") {
            result.update((val) {
              var list = <Artist>[];
              list..addAll(val.artistList)..addAll(data.artistList);
              val.artistList = list;
            });
          }
        }
        // TODO: 加载更多页面不刷新
        pagingState.page++;
      }
    } catch (e) {
      print(e);
      print("搜索结果出错");
      error.value = true;
    }
  }

  loadSearchKeys() async {
    try {
      var res = await Provider.getSearchKey(keyword.value);
      if (res.ok) {
        searchKeys.value = [];
        res.data?.forEach((v) {
          var item = v.toString().split("\n")[0].split("=")[1];
          searchKeys.add(item);
        });
      }
    } catch (e) {
      print("网络错误");
    }
  }

  loadHotKeys() async {
    try {
      var res = await Provider.getSearchKey("");
      if (res.ok) {
        hotKeys.value = [];
        res.data?.forEach((v) {
          hotKeys.add(v.toString());
        });
      }
    } catch (e) {
      print(e);
      print("网络错误");
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await loadHotKeys();
    keyword?.listen(Utils.debounce((key) {
      result.value = null;
      isResult.value = false;
      loadSearchKeys();
    }));
    tabController.addListener(() {
      pagingState.reset();
      result.value = null;
      if (tabController.index == 0) {
        search();
      }
      if (tabController.index == 1) {
        search(type: "Artist");
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
    searchController.dispose();
    easyController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    searchController = TextEditingController();
    easyController = EasyRefreshController();
    result.value = null;
  }
}
