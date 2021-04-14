import 'package:flutter_make_music/model/song.dart';

// 榜单详情和歌曲列表
class BangDetail {
  String img;
  String num;
  String pub;
  List<Song> musicList;

  BangDetail({this.img, this.num, this.pub, this.musicList = const []});

  BangDetail.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    num = json['num'];
    pub = json['pub'];
    musicList = [];
    json['musicList']?.forEach((song) {
      musicList.add(Song.fromJson(song));
    });
  }

  @override
  String toString() {
    return 'BangDetail{img: $img, num: $num, pub: $pub, musicList: $musicList}';
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['img'] = this.img;
    data['num'] = this.num;
    data['pub'] = this.pub;
    data['musicList'] = this.musicList.map((song) => song.toJson());
    return data;
  }
}

// 榜单列表数据
class BangModel {
  List<BangType> bangMenu;

  BangModel({this.bangMenu});

  BangModel.fromJson(List<dynamic> data) {
    bangMenu = <BangType>[];
    if (data != null) {
      (data as List<BangType>).forEach((v) {
        bangMenu.add(v);
      });
    }
  }

  List<dynamic> toJson() {
    var data = <dynamic>[];
    data = this.bangMenu.map((e) => e.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'BangModel{bangMenu: $bangMenu}';
  }
}

// 榜单大分类
class BangType {
  String name;
  List<BangItem> list;

  BangType({this.name, this.list});

  BangType.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    list = <BangItem>[];
    if (json['list'] != null) {
      (json['list'] as List<BangItem>).forEach((bang) {
        list.add(bang);
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['name'] = this.name;
    data['list'] = this.list.map((e) => e.toJson());
    return data;
  }

  @override
  String toString() {
    return 'BangType{name: $name, list: $list}';
  }
}

// 单个榜单信息
class BangItem {
  String id; // 榜单id
  String intro; // 简介
  String name; // 名
  String pic; // 图片
  String pub; // 更新时间
  String source; // 未知
  String sourceid; // 用于获取榜单歌曲的id

  BangItem(
      {this.id,
      this.intro,
      this.name,
      this.pic,
      this.pub,
      this.source,
      this.sourceid});

  BangItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    intro = json['intro'];
    name = json['name'];
    pic = json['pic'];
    pub = json['pub'];
    source = json['source'];
    sourceid = json['sourceid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['intro'] = this.intro;
    data['name'] = this.name;
    data['pic'] = this.pic;
    data['pub'] = this.pub;
    data['source'] = this.source;
    data['sourceid'] = this.sourceid;
    return data;
  }

  @override
  String toString() {
    return 'BangItem{id: $id, intro: $intro, name: $name, pic: $pic, pub: $pub, source: $source, sourceid: $sourceid}';
  }
}
