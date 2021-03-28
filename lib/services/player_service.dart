import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_make_music/api/provider/index.dart';
import 'package:flutter_make_music/model/lyric.dart';
import 'package:flutter_make_music/model/song.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

enum PLAY_MODE { list, random, one, no }

class PlayerService extends GetxService {
  final loading = false.obs; // 歌曲加载状态
  final canOperator = true.obs; // 是否能操作上一曲下一曲
  final currIndex = 0.obs; // 当前歌曲索引
  final playMode = PLAY_MODE.random.obs; // 播放模式
  final totalTime = 0.0.obs; // 总时间
  final currentTime = 0.obs; // 当前播放进度
  final playing = false.obs; // 播放状态
  final songUri = "".obs; // 歌曲 uri

  // 歌词
  final lyric = Lyric().obs;

  final playList = <Song>[].obs;

  final player = AudioPlayer();

  final percent = 0.0.obs;

  final currentLien = 0.obs;

  final currentLyricStr = "".obs;

  final nextLyricStr = "".obs;

  // 是否按下进度条
  bool isTouch = false;

  Song get currSong {
    if (playList.length == 0) {
      return null;
    }
    return playList[currIndex.value];
  }

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

  int modeCount = 0;

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

  // 播放列表数量
  int get songCount => playList.length;

  // 播放进度百分比
  changePercent() {
    if (totalTime.value == 0) return 0;
    if (!isTouch) {
      percent.value = (currentTime.value / totalTime.value).toDouble();
    }
  }

  changeCurrentLine() {
    if (currSong == null || lyric?.value?.lyrics == null) return null;
    var len = lyric.value.lyrics.length;
    var lyrics = lyric.value.lyrics;
    for (int i = 0; i < len; i++) {
      var lineTime = lyrics[i];
      var nextLineTime = i == len - 1 ? lyrics[len - 1] : lyrics[i + 1];
      if (currentTime >= lineTime.time && currentTime < nextLineTime.time) {
        currentLien.value = i;
        currentLyricStr.value = lyrics[i].lineLyric;
        nextLyricStr.value = lyrics[i >= len - 1 ? len - 1 : i + 1].lineLyric;
      }
    }
  }

  pause() async {
    if (currSong == null) return;
    await player.pause();
  }

  play() async {
    if (currSong == null) return;
    await player.play();
  }

  seekTime(int seconds) async {
    if (currSong == null) return;
    await player.seek(Duration(seconds: seconds));
  }

  // 播放初始化
  playInit() async {
    loading.value = true;
    currentTime.value = 0;
    songUri.value = "";
    lyric.value = null;
    await pause();
  }

  // 加载歌曲播放
  loadPlay() async {
    playInit();
    if (currSong == null) return;
    canOperator.value = false;
    try {
      var res = await Provider.getUri(currSong.rid.toString());
      var lrcRes = await Provider.getLyric(currSong.rid.toString());
      if (lrcRes.ok) {
        lyric.value = Lyric.fromJson(lrcRes.data);
        print(lyric.value);
      }
      if (res.ok) {
        songUri.value = res.data;
        var duration = await player.setUrl("${res.data}");
        totalTime.value = duration.inSeconds.toDouble();
        await player.play();
        canOperator.value = true;
      }
    } catch (e) {
      print(e);
      Get.snackbar("title", "播放出错");
      next();
    }
  }

  // 加载歌曲列表并播放
  loadListAndPlay(int index, List<Song> list) async {
    playInit();
    if (list.length == 0) return;
    var song = list[index];
    if (song == null) return;
    playList.value = list;
    currIndex.value = index;
    loadPlay();
  }

  // 夏一首歌
  next() async {
    await playInit();
    if (!canOperator.value) return;

    if (playMode.value == PLAY_MODE.random) {
      randomIndex();
    } else {
      if (currIndex.value >= songCount - 1) {
        currIndex.value = 0;
      } else {
        currIndex.value++;
      }
    }
    loadPlay();
  }

  randomIndex() {
    currIndex.value = Random().nextInt((songCount - 1) < 0 ? 0 : songCount - 1);
  }

  // 上一首歌
  previous() async {
    await playInit();
    if (!canOperator.value) return;
    if (currIndex.value == 0) {
      currIndex.value = songCount - 1;
    } else {
      currIndex.value--;
    }
    loadPlay();
  }

  @override
  void onReady() {
    super.onReady();
    player.durationStream.listen((event) {});
    player.positionStream.listen((event) {
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
          // TODO: 处理播放完成后时间
          switch (playMode.value) {
            case PLAY_MODE.one:
              seekTime(0);
              break;
            default:
              next();
              break;
          }
          print("播放 completed");
          break;
        default:
          break;
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    // playInit();
  }

  @override
  void onClose() {
    super.onClose();
    player.stop();
    player.dispose();
  }
}
