class Song {
  String artist;
  int artistid;
  int duration;
  int hasmv;
  int mvPlayCnt;
  String name;
  String pic;
  String pic120;
  String releaseDate;
  int rid;
  String songTimeMinutes;

  Song(
      {this.artist,
      this.artistid,
      this.duration,
      this.hasmv,
      this.mvPlayCnt,
      this.name,
      this.pic,
      this.pic120,
      this.releaseDate,
      this.rid,
      this.songTimeMinutes});

  Song.fromJson(Map<String, dynamic> json) {
    artist = json['artist'];
    artistid = json['artistid'];
    duration = json['duration'];
    hasmv = json['hasmv'];
    mvPlayCnt = json['mvPlayCnt'];
    name = json['name'];
    pic = json['pic'];
    pic120 = json['pic120'];
    releaseDate = json['releaseDate'];
    rid = json['rid'];
    songTimeMinutes = json['songTimeMinutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artist'] = this.artist;
    data['artistid'] = this.artistid;
    data['duration'] = this.duration;
    data['hasmv'] = this.hasmv;
    data['mvPlayCnt'] = this.mvPlayCnt;
    data['name'] = this.name;
    data['pic'] = this.pic;
    data['pic120'] = this.pic120;
    data['releaseDate'] = this.releaseDate;
    data['rid'] = this.rid;
    data['songTimeMinutes'] = this.songTimeMinutes;
    return data;
  }

  @override
  String toString() {
    return 'Song{artist: $artist, artistid: $artistid, duration: $duration, hasmv: $hasmv, mvPlayCnt: $mvPlayCnt, name: $name, pic: $pic, pic120: $pic120, releaseDate: $releaseDate, rid: $rid, songTimeMinutes: $songTimeMinutes}';
  }
}
