import 'package:flutter_make_music/model/song.dart';

class MySong extends Song {
  int id;
  String name;
  String artist;
  String pic;
  DateTime createAt;
  DateTime updateAt;
  int get rid => id;
  MySong(
      {this.id,
      this.name,
      this.artist,
      this.pic,
      this.createAt,
      this.updateAt});
  MySong.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    artist = json['artist'];
    pic = json['pic'];
    createAt = DateTime.parse(json['createAt']);
    updateAt = DateTime.parse(json['updateAt']);
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'artist': artist,
      'pic': pic,
      'createAt': createAt.toString(),
      'updateAt': updateAt.toString()
    };
  }

  @override
  String toString() {
    return 'MySong{id: $id, name: $name, artist: $artist, pic: $pic, createAt: $createAt, updateAt: $updateAt}';
  }
}

class MyPlaylist {
  int id;
  String name;
  String pic;
  int totalCount;
  String info;
  DateTime createAt;
  DateTime updateAt;
  List<Song> musicList;
  MyPlaylist(
      {this.id,
      this.name,
      this.pic,
      this.totalCount,
      this.info,
      this.createAt,
      this.updateAt,
      this.musicList});
  MyPlaylist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pic = json['pic'];
    totalCount = json['totalCount'];
    info = json['info'];
    print(json);
    createAt = DateTime.parse(json['createAt']);
    updateAt = DateTime.parse(json['updateAt']);
    musicList =
        (json['musicList'] as List)?.map((e) => Song.fromJson(e))?.toList() ??
            [];
  }

  @override
  String toString() {
    return 'MyPlaylist{id: $id, name: $name, pic: $pic, totalCount: $totalCount, info: $info, createAt: $createAt, updateAt: $updateAt, musicList: $musicList}';
  }
}

class User {
  int id;
  String username;
  String avatar;
  String favorites;
  int listenCount;
  String recentPlay;
  List<MyPlaylist> playList;
  DateTime createAt;
  DateTime updateAt;
  String token;
  int get playlistCount {
    return playList?.length ?? 0;
  }

  int get favoriteCount {
    if (favorites.isEmpty) return 0;
    return favorites?.split(",")?.length ?? 0;
  }

  int get recentPlayCount {
    return recentPlay?.split(",")?.length ?? 0;
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    avatar = json['avatar'];
    favorites = json['favorites'];
    listenCount = json['listenCount'];
    recentPlay = json['recentPlay'];
    playList = (json['playList'] as List)
        ?.map((e) => MyPlaylist.fromJson(e))
        ?.toList();
    createAt = DateTime.parse(json['createAt']);
    updateAt = DateTime.parse(json['updateAt']);
    token = json['token'];
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, avatar: $avatar, favorites: $favorites, listenCount: $listenCount, recentPlay: $recentPlay, playList: $playList, createAt: $createAt, updateAt: $updateAt}';
  }
}
