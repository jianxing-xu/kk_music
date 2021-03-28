class PageNetState {
  String errorMessage = "网络好像出问题了，点击刷新重试。";
  var loading = true;
  var error = false;

  init() {
    loading = true;
    error = false;
  }

  success() {
    error = false;
    loading = false;
  }

  thError() {
    error = true;
    loading = false;
  }

  @override
  String toString() {
    return 'PageNetState{errorMessage: $errorMessage, loading: $loading, error: $error}';
  }
}
