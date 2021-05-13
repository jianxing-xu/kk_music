// 歌词模型
class Lyric {
  List<LyricLine> lyrics;

  Lyric({this.lyrics});

  Lyric.fromJson(Map<String, dynamic> json) {
    lyrics = <LyricLine>[];
    if (json['lrc'] != null) {
      json['lrc']?.forEach((v) {
        lyrics.add(LyricLine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'lrc': lyrics?.map((e) => e.toJson())};
  }

  @override
  String toString() {
    return 'Lyric{lyrics: $lyrics}';
  }
}

class LyricLine {
  String lineLyric;
  double time;

  LyricLine({this.lineLyric, this.time});

  LyricLine.fromJson(Map<String, dynamic> json) {
    lineLyric = json['lineLyric'];
    time = double.parse(json['time']);
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{'lineLyric': lineLyric, 'time': time};
    return data;
  }

  @override
  String toString() {
    return 'LyricLine{lineLyric: $lineLyric, time: $time}';
  }
}
