class Song {
  String artist;
  int artistid;
  int duration;
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
      this.name,
      this.pic,
      this.pic120,
      this.releaseDate,
      this.rid,
      this.songTimeMinutes});

  Song.fromJson(Map<String, dynamic> json) {
    artist = json['artist'];
    print(json['artistid'].runtimeType);
    artistid = int.parse(json['artistid'].toString());
    duration = int.parse(json['duration'].toString());
    name = json['name'];
    pic = json['pic'];
    pic120 = json['pic120'];
    releaseDate = json['releaseDate'];
    rid = int.parse(json['rid'].toString());
    songTimeMinutes = json['songTimeMinutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artist'] = this.artist;
    data['artistid'] = this.artistid;
    data['duration'] = this.duration;
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
    return 'Song{artist: $artist, artistid: $artistid, duration: $duration, name: $name, pic: $pic, pic120: $pic120, releaseDate: $releaseDate, rid: $rid, songTimeMinutes: $songTimeMinutes}';
  }
}
