import 'package:flutter_make_music/model/song.dart';

class Artist {
  int id;
  int artistFans;
  String content_type;
  String country;
  int isStar;
  int musicNum;
  String name;
  String pic;

  Artist(
      {this.id,
      this.artistFans,
      this.content_type,
      this.country,
      this.isStar,
      this.musicNum,
      this.name,
      this.pic});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    artistFans = json['artistFans'];
    content_type = json['content_type'];
    country = json['country'];
    isStar = json['isStar'];
    musicNum = json['musicNum'];
    name = json['name'];
    pic = json['pic'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'artistFans': artistFans,
      'content_type': content_type,
      'country': country,
      'isStar': isStar,
      'musicNum': musicNum,
      'name': name,
      'pic': pic,
    };
  }

  @override
  String toString() {
    return 'Artist{id: $id, artistFans: $artistFans, content_type: $content_type, country: $country, isStar: $isStar, musicNum: $musicNum, name: $name, pic: $pic}';
  }
}

class SearchResult {
  List<Song> list;
  List<Artist> artistList;
  int total;

  SearchResult({this.list, this.total,this.artistList});

  SearchResult.fromJson(Map<String, dynamic> json) {
    list = <Song>[];
    json['list']?.forEach((v) {
      list.add(Song.fromJson(v));
    });
    artistList = <Artist>[];
    json['artistList']?.forEach((v) {
      artistList.add(Artist.fromJson(v));
    });
    total = int.parse(json['total']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'list': list.map((e) => e.toJson()).toList(),
      'total': total.toString()
    };
  }

  @override
  String toString() {
    return 'SearchResult{list: $list, artistList: $artistList, total: $total}';
  }
}
