class HomeModel {
  List<BannerItem> bannerList;
  List<HPlayListItem> playList;
  List<HRankItem> rankList;

  HomeModel({this.bannerList, this.playList, this.rankList});

  HomeModel.fromJson(Map<String, dynamic> json) {
    bannerList = (json["banner_list"] as List)
        ?.map((v) => BannerItem.fromJson(v))
        ?.toList();
    playList = (json["playlist_list"] as List)
        ?.map((e) => HPlayListItem.fromJson(e))
        ?.toList();
    rankList = (json["rank_list"] as List)
        ?.map((e) => HRankItem.fromJson(e))
        ?.toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data["banner_list"] = this.bannerList?.map((e) => e.toJson())?.toList();
    data["playlist_list"] = this.playList?.map((e) => e.toJson())?.toList();
    data["rank_list"] = this.rankList?.map((e) => e.toJson())?.toList();
    return data;
  }

  @override
  String toString() {
    return 'HomeModel{bannerList: $bannerList, playList: $playList, rankList: $rankList}';
  }
}

// 首页单个榜单 和 榜单详情都是
class HRankItem {
  String label;
  List<HSong> list; //单个榜单只有三条
  String publish;
  String total;
  String typeId;
  String picIcon;

  HRankItem({
    this.label,
    this.list,
    this.publish,
    this.total,
    this.typeId,
    this.picIcon,
  });

  // 转模型时兼容榜单列表页的不同属性
  HRankItem.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    list = <HSong>[];
    json['list']?.forEach((v) {
      list.add(HSong.fromJson(v));
    });
    picIcon = json["pic_icon"];
    publish = json['publish'];
    total = json['total'];
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['label'] = this.label;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['publish'] = this.publish;
    data['total'] = this.total;
    data['type_id'] = this.typeId;
    data["pic_icon"] = this.picIcon;
    return data;
  }

  @override
  String toString() {
    return 'RankItem{label: $label, list: $list, publish: $publish, total: $total, typeId: $typeId}';
  }
}

// 单个歌单模型
class HPlayListItem {
  String id;
  String name;
  String artistName;
  String countPlay;
  String pic;

  HPlayListItem(
      {this.id, this.name, this.artistName, this.countPlay, this.pic});

  HPlayListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pic = json["pic"] ?? json['img'];
    countPlay = json["count_play"] ?? json['listencnt'];
    name = json['name'];
    artistName = json["artist_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pic'] = this.pic;
    data['count_play'] = this.countPlay;
    data['name'] = this.name;
    data['artist_name'] = artistName;
    return data;
  }

  @override
  String toString() {
    return 'PlayListItem{id: $id, name: $name, artistName: $artistName, countPlay: $countPlay, pic: $pic}';
  }
}

// 各种中显示的单个歌曲
class HSong {
  String albumName;
  String artistName;
  String id;
  int mvStatus;
  String name;
  String pic;

  HSong(
      {this.albumName,
      this.artistName,
      this.id,
      this.mvStatus,
      this.name,
      this.pic});

  HSong.fromJson(Map<String, dynamic> json) {
    albumName = json['album_name'];
    artistName = json['artist_name'];
    id = json['id'].toString();
    mvStatus = json['mv_status'];
    name = json['name'];
    pic = json['pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['album_name'] = this.albumName;
    data['artist_name'] = this.artistName;
    data['id'] = this.id;
    data['mv_status'] = this.mvStatus;
    data['name'] = this.name;
    data['pic'] = this.pic;
    return data;
  }

  @override
  String toString() {
    return 'Song{albumName: $albumName, artistName: $artistName, id: $id, mvStatus: $mvStatus, name: $name, pic: $pic}';
  }
}

// 单个轮播
class BannerItem {
  int id;
  String digest;
  String pic;
  String detail;

  BannerItem({this.id, this.digest, this.pic, this.detail});

  BannerItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    digest = json['digest'];
    pic = json['pic'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['digest'] = this.digest;
    data['pic'] = this.pic;
    data['detail'] = this.detail;
    return data;
  }

  @override
  String toString() {
    return 'BannerItem{id: $id, digest: $digest, pic: $pic, detail: $detail}';
  }
}
