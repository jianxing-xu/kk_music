import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/app_response.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/lyric.dart';
import 'package:flutter_make_music/model/song.dart';
import 'package:flutter_make_music/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

enum PLAY_MODE { list, random, one, no }

class PlayerService extends GetxService {
  AudioPlayer player; // 播放器实例
  PlayerService() {
    player?.stop();
    player?.dispose();
    player = AudioPlayer();
  }

  final Rx<Song> song = Rx<Song>(null); // 当前歌曲

  final loading = false.obs; // 歌曲加载状态

  final playMode = PLAY_MODE.random.obs; // 播放模式

  final totalTime = 0.0.obs; // 总时间

  final currentTime = 0.obs; // 已播放时间

  final playing = false.obs; // 播放状态

  final playList = <Song>[].obs; // 播放列表
  int get songCount => playList.length; // 播放列表数量

  final percent = 0.0.obs; // 播放进度百分比

  final currentLyricStr = "".obs; // 正在播放的歌词

  final nextLyricStr = "".obs; // 下一行歌词

  // 是否按下进度条
  bool isTouch = false;

  Lyric lyric; // 歌词对象

  final currIndex = (-1).obs; // 当前歌曲索引

  bool canOperator = true; // 是否能操作上一曲下一曲

  int currentLien = 0; // 当前播放歌词行

  // 播放模式icon
  int modeCount = 0;

  IconData get modeIcon {
    switch (playMode.value) {
      case PLAY_MODE.random:
        return Icons.shuffle;
      case PLAY_MODE.list:
        return Icons.repeat;
      case PLAY_MODE.one:
        return Icons.repeat_one;
      default:
        return Icons.close;
    }
  }

  String get modeText {
    switch (playMode.value) {
      case PLAY_MODE.random:
        return "随机播放 (${playList.length ?? 0}首歌)";
      case PLAY_MODE.list:
        return "顺序播放 (${playList.length ?? 0}首歌)";
      case PLAY_MODE.one:
        return "单曲循环";
      default:
        return "--";
    }
  }

  // 修改播放模式
  changeMode() {
    modeCount++;
    switch (modeCount % 3) {
      case 0:
        playMode.value = PLAY_MODE.random;
        break;
      case 1:
        playMode.value = PLAY_MODE.list;
        break;
      case 2:
        playMode.value = PLAY_MODE.one;
        break;
    }
  }

  // 播放进度百分比
  changePercent() {
    if (totalTime.value == 0) return 0;
    if (!isTouch) {
      var v = (currentTime.value / totalTime.value).toDouble();
      v = v > 1 ? 1 : v;
      v = v < 0 ? 0 : v;
      percent.value = v;
    }
  }

  changeCurrentLine() {
    if (song == null || lyric?.lyrics == null) return null;
    var len = lyric.lyrics.length;
    var lyrics = lyric.lyrics;
    for (int i = 0; i < len; i++) {
      var lineTime = lyrics[i];
      var nextLineTime = i == len - 1 ? lyrics[len - 1] : lyrics[i + 1];
      if (currentTime >= lineTime.time && currentTime < nextLineTime.time) {
        currentLien = i;
        currentLyricStr.value = lyrics[i].lineLyric;
        nextLyricStr.value = lyrics[i >= len - 1 ? len - 1 : i + 1].lineLyric;
      }
    }
  }

  // 控制播放
  pause() async {
    if (song.value == null) return;
    await player.pause();
  }

  // 控制暂停
  play() async {
    if (song.value == null) return;
    await player.play();
  }

  // 跳转到指定时间
  seekTime(int seconds) async {
    if (song == null) return;
    print("SEEK_TIME");
    await player.seek(Duration(seconds: seconds));
  }

  // 开始播放一首新歌的初始化工作
  playInit() async {
    await pause();
    loading.value = false;
    currentTime.value = 0;
    totalTime.value = 0;
    percent.value = 0;
    lyric = null;
    nextLyricStr.value = "--";
    currentLyricStr.value = "--";
    canOperator = false;
    print("设置canOprator FALSE");
    currentLien = -1;
    song.value = null;
  }

  // 设置播放列表数据
  setPlayList(List<Song> list) {
    if (list == null || list.length == 0) return;
    playList.value = list;
  }

  // 设置当前播放索引
  setCurrentIndex([int index]) {
    currIndex.value = index;
    loadPlay();
  }

  // 加载歌曲播放
  loadPlay() async {
    // 如果歌曲不为null 且 当前播放歌曲和新的索引歌曲rid相同则 return
    if (song.value != null && song.value.rid == playList[currIndex.value].rid) {
      return print("相同歌曲");
    }
    // 播放前的初始化
    await playInit();
    // 赋值当前歌曲
    song.value = playList[currIndex.value];

    //-----TODO：分两次请求导致歌词延迟到达而导致，歌曲和歌词不匹配问题 ----//

    Provider.getUri(song.value.rid.toString()).then((res) async {
      if (res.ok) {
        var duration = await player.setUrl("${res.data}");
        totalTime.value = duration.inSeconds.toDouble();
        canOperator = true;
        await player.play().catchError((e) {});
        isComplete = false;
      }
    }).catchError((e) {
      print("加载歌曲错误");
      next(false);
    });
    Provider.getLyric(song.value.rid.toString()).then((res) {
      if (res.ok) {
        lyric = Lyric.fromJson(res.data);
      }
    }).catchError((e) {
      print("加载歌词错误");
    });
  }

  // 下一首歌
  next([bool check = true]) async {
    if (check) if (!canOperator) return;
    if (playMode.value == PLAY_MODE.one) return seekTime(0);
    if (playMode.value == PLAY_MODE.random) {
      randomIndex();
    } else {
      if (currIndex.value >= songCount - 1) {
        currIndex.value = 0;
      } else {
        currIndex.value++;
      }
      print("NEXT_INDEX: ${currIndex.value}");
    }
    loadPlay();
  }

  randomIndex() {
    if (songCount == 1) {
      return seekTime(0);
    }
    currIndex.value = Random().nextInt(songCount);
  }

  // 跳转到某一首
  jumpToForIndex(int index) {
    currIndex.value = index;
    loadPlay();
  }

  // 上一首歌
  previous() async {
    if (!canOperator) return;
    if (currIndex.value == 0) {
      currIndex.value = songCount - 1;
    } else {
      currIndex.value--;
    }
    loadPlay();
  }

  // 插入一首歌曲并播放 （需要改变索引）
  insertSongInPlayList(Song song) {
    //插入一首歌曲并播放 （需要改变索引）
    var index = playList.indexWhere((item) => item.rid == song.rid);
    if (index != -1) {
      // 在列表中找到了这首歌
      setCurrentIndex(index);
    } else {
      // 没找到 要插入
      if (currIndex.value < 0) {
        playList.insert(0, song);
        setCurrentIndex(0);
      } else {
        playList.insert(currIndex.value, song);
        setCurrentIndex(currIndex.value);
      }
    }
    Get.toNamed(Routes.Player);
  }

  // 删除列表中的一首歌曲（需要改变索引）
  deleteSongToPlayList(Song tSong) async {
    // 删除列表中的一首歌曲（需要改变索引）
    var index = playList.indexWhere((item) => item.rid == tSong.rid);
    // 删除的是当前播放的歌曲
    playList.removeWhere((item) => item.rid == tSong.rid);
    if (index == currIndex.value) {
      playInit();
    } else {
      if (index < currIndex.value) {
        currIndex.value--;
      }
    }
  }

  bool isComplete = false;

  @override
  void onReady() {
    super.onReady();
    player.durationStream.listen((event) {});
    player.positionStream.listen((event) {
      if (isTouch) return;
      currentTime.value = event.inSeconds;
      changePercent();
      changeCurrentLine();
    });
    player.playerStateStream.listen((state) {
      playing.value = state.playing;
      switch (state.processingState) {
        case ProcessingState.idle:
          break;
        case ProcessingState.loading:
          loading.value = true;
          print("播放 loading");
          break;
        case ProcessingState.buffering:
          loading.value = true;
          print("播放 buffering");
          break;
        case ProcessingState.ready:
          loading.value = false;
          print("播放 ready");
          break;
        case ProcessingState.completed:
          // 此处的complete回调会执行两次，需要用一个变量判断，否则会导致执行两次next()
          if (isComplete) return;
          isComplete = true;
          print("播放 completed");
          if (playList.length == 1) return seekTime(0);
          //  处理播放完成后时间
          switch (playMode.value) {
            case PLAY_MODE.one:
              seekTime(0);
              break;
            default:
              next();
              break;
          }

          break;
        default:
          break;
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    player.stop();
    player.dispose();
  }
}
