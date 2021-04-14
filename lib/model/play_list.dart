import 'package:flutter_make_music/model/song.dart';

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
    id = json['id'];
    img = json['img'];
    info = json['info'];
    musicList = json['musicList']?.map((v) => Song.fromJson(v))?.toList();
    name = json['name'];
    tag = json['tag'];
    total = json['total'];
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
