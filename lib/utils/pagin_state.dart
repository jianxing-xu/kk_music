class PagingState {
  int pageNum = 20;

  int total = 0;
  int page = 1;
  bool isLoading = false;

  bool isFirst = true;

  PagingState({this.pageNum = 50});

  // 是否到加载完了
  bool get isEnd => pageNum * page > total;

  reset() {
    isFirst = false;
    page = 0;
    isLoading = false;
  }

  nextPage() {
    if (isEnd) return;
    isLoading = true;
    page++;
  }

  loaded() {
    isLoading = false;
  }

  @override
  String toString() {
    return 'PagingState{pageNum: $pageNum, total: $total, page: $page, isLoading: $isLoading, isFirst: $isFirst, isEnd: $isEnd}';
  }
}
