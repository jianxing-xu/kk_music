import 'package:flutter_make_music/model/home_model.dart';
import 'package:flutter_make_music/model/song.dart';

class PlayListAll {
  List<HPlayListItem> data;
  int pn;
  int rn;
  int total;
  PlayListAll({this.data, this.pn, this.rn, this.total});
  PlayListAll.fromJson(Map<String, dynamic> json) {
    data = (json['data'] as List)
            ?.map((e) => HPlayListItem.fromJson(e))
            ?.toList() ??
        [];
    pn = json['pn'];
    rn = json['rn'];
    total = json['total'];
  }
}

class PlayList {
  int id;
  String img;
  String info;
  List<Song> musicList;
  String name;
  String tag;
  int total;
  String userName;
  String uPic;

  PlayList(
      {this.id,
      this.img,
      this.info,
      this.musicList,
      this.name,
      this.tag,
      this.total,
      this.userName,
      this.uPic});

  PlayList.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    img = json['img'];
    info = json['info'];
    musicList =
        (json['musicList'] as List)?.map((v) => Song.fromJson(v))?.toList();
    name = json['name'];
    tag = json['tag'];
    total = int.parse(json['total'].toString());
    userName = json['userName'];
    uPic = json['uPic'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'img': img,
      'info': info,
      'musicList': musicList.map((v) => v.toJson()).toList(),
      'name': name,
      'tag': tag,
      'total': total,
      'userName': userName,
      'uPic': uPic
    };
  }

  @override
  String toString() {
    return 'PlayList{id: $id, img: $img, info: $info, musicList: $musicList, name: $name, tag: $tag, total: $total, userName: $userName, uPic: $uPic}';
  }
}
