import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/search_result.dart';
import 'package:flutter_make_music/utils/pagin_state.dart';
import 'package:flutter_make_music/utils/utils.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchController extends GetxController
    with SingleGetTickerProviderMixin {
  final cancelToken = CancelToken();

  TabController tabController;
  TextEditingController searchController;
  PagingState pagingState = PagingState(); // 分页状态
  final keyword = "".obs; // 关键词

  final hotKeys = <String>[].obs; // 热词数据
  final searchKeys = <String>[].obs; // 推荐词

  final Rx<SearchResult> result = Rx<SearchResult>();

  final isResult = false.obs;

  int get indexed {
    if (isResult.value) return 2;
    if (keyword.value.isEmpty) return 0;
    return 1;
  }

  /// ------------------------ FIX ------------------------- ///

  // Pull To Refresh Controller
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final resultFuture = Rx<Future>(null);

  // 初始化搜索，
  initSearch({String type = "Music"}) {
    if (!isResult.value) isResult.value = true;
    pagingState.reset();
    refreshController.loadComplete();
    resultFuture.value = Provider.getSearchResult(
            keyword.value, type, pagingState.page, pagingState.pageNum)
        .then((res) {
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
