import 'package:flutter_make_music/model/song.dart';

class Artist {
  int id;
  int artistFans;
  String contentType;
  String country;
  int isStar;
  int musicNum;
  String name;
  String pic;

  Artist(
      {this.id,
      this.artistFans,
      this.contentType,
      this.country,
      this.isStar,
      this.musicNum,
      this.name,
      this.pic});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    artistFans = json['artistFans'];
    contentType = json['content_type'];
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
      'content_type': contentType,
      'country': country,
      'isStar': isStar,
      'musicNum': musicNum,
      'name': name,
      'pic': pic,
    };
  }

  @override
  String toString() {
    return 'Artist{id: $id, artistFans: $artistFans, content_type: $contentType, country: $country, isStar: $isStar, musicNum: $musicNum, name: $name, pic: $pic}';
  }
}

class SearchResult {
  List<Song> list;
  List<Artist> artistList;
  int total;

  SearchResult({this.list, this.total, this.artistList});

  SearchResult.fromJson(Map<String, dynamic> json, [String type = "Music"]) {
    list = <Song>[];
    if (type == "Music") {
      json['list']?.forEach((v) {
        list.add(Song.fromJson(v));
      });
    }
    artistList = <Artist>[];
    json['artistList']?.forEach((v) {
      artistList.add(Artist.fromJson(v));
    });
    total = int.parse(json['total']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'list': list.map((e) => e.toJson()).toList(),
      'total': total
    };
  }

  @override
  String toString() {
    return 'SearchResult{list: $list, artistList: $artistList, total: $total}';
  }
}
