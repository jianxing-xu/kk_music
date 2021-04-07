import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/search_result.dart';
import 'package:flutter_make_music/utils/pagin_state.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchController extends GetxController
    with SingleGetTickerProviderMixin {
  final cancelToken = CancelToken();

  TabController tabController; // 结果页 tab view 控制器

  TextEditingController searchController; // 搜索输入框控制器

  PagingState pagingState = PagingState(); // 分页状态

  final keyword = "".obs; // 关键词

  final hotKeys = <String>[].obs; // 热词数据

  final searchKeys = <String>[].obs; // 推荐词

  final Rx<SearchResult> result = Rx<SearchResult>(); // 搜索结果

  final isResult = false.obs; // 是否显示搜索结果页面

  // 三种模式的层级 0：NormalWidget, 1：SuggestWidget, 2：ResultWidget
  int get indexed {
    if (isResult.value) return 2;
    if (keyword.value.isEmpty) return 0;
    return 1;
  }

  /// ------------------------ FIX ------------------------- ///

  // Pull To Refresh Controller 刷新插件控制器
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  // 搜索结果的异步状态
  final resultFuture = Rx<Future>(null);

  // 初始化搜索数据
  initSearch({String type = "Music"}) {
    if (!isResult.value) isResult.value = true;
    pagingState.reset();
    refreshController.loadComplete();
    resultFuture.value = Provider.getSearchResult(
            keyword.value, type, pagingState.page, pagingState.pageNum)
        .then((res) {
      print("PAGING: $pagingState");
      if (res.ok) {
        var data = SearchResult.fromJson(res.data);
        // 当在歌手列表时，删除附带的歌曲数据
        if (type == "Artist") {
          data.list = null;
        }
        pagingState.total = data.total;
        result.value = data;
        return data;
      }
    }).catchError((e) {
      throw e;
    });
  }

  // 加载更多数据
  loadMore({String type = "Music"}) async {
    print(pagingState);
    if (pagingState.isEnd) return refreshController.loadNoData();
    pagingState.nextPage();
    try {
      var res = await Provider.getSearchResult(
          keyword.value, type, pagingState.page, pagingState.pageNum);
      if (res.ok) {
        var data = SearchResult.fromJson(res.data);
        result.update((val) {
          if (type == "Music") {
            val.list.addAll(data.list);
          } else {
            val.artistList.addAll(data.artistList);
          }
        });
        refreshController.loadComplete();
      }
    } catch (e) {
      refreshController.loadFailed();
      pagingState.page--;
    }
  }

  // 刷新结果数据
  refreshData({String type = "Music"}) async {
    pagingState.reset();
    try {
      var res = await Provider.getSearchResult(
          keyword.value, type, pagingState.page, pagingState.pageNum);
      if (res.ok) {
        var data = SearchResult.fromJson(res.data);
        result.update((val) {
          if (type == "Music") {
            val.list = data.list;
          } else {
            val.artistList = data.artistList;
          }
        });
        refreshController.refreshCompleted();
      }
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  // 搜索推荐词数据
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

  // 加载热门搜索词
  loadHotKeys() async {
    // TODO: 加载热搜词的loading
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

  // 搜索框聚焦监听
  onFocus(bool focus) {
    // 聚焦时，清楚搜索result和隐藏result
    if (focus) {
      isResult.value = false;
      result.value = null;
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await loadHotKeys();

    // 搜索栏的防抖
    debounce<String>(keyword, (value) {
      // 如果搜索词为空，或者在结果页面下，就不进行suggest搜索
      if (value.isEmpty || isResult.value) return searchKeys.clear();
      loadSearchKeys();
    }, time: Duration(milliseconds: 200));

    // 搜索结果 tab bar 的修改监听
    tabController.addListener(() {
      if (tabController.index == 0) {
        result.update((val) {
          val.artistList = null;
        });
        initSearch();
      } else if (tabController.index == 1) {
        result.update((val) {
          val.list = null;
        });
        initSearch(type: "Artist");
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    searchController = TextEditingController();
    result.value = null;
    super.onInit();
  }
}
