import 'dart:async';

import 'package:flutter/cupertino.dart';

class Utils {
  static formatTime(double seconds) {
    var minus = (seconds / 60).floor().toString();
    var second = (seconds % 60).toInt().toString();
    if (minus.length == 1) {
      minus = "0$minus";
    }
    if (second.length == 1) {
      second = "0$second";
    }
    return "$minus:$second";
  }

  static ValueChanged debounce(ValueChanged callback,
      {Duration time = const Duration(milliseconds: 400)}) {
    Timer timer;
    return (key) {
      if (timer?.isActive ?? false) {
        timer?.cancel();
        timer = Timer(time, () {
          callback?.call(key);
        });
      } else {
        timer = Timer(time, () {
          callback?.call(key);
        });
      }
    };
  }

  static hideKeyBoard(BuildContext context) {
    FocusManager?.instance?.primaryFocus?.unfocus();
  }
}
