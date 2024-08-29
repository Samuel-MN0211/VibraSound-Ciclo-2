import 'package:flutter/material.dart';

class BpmModel extends ChangeNotifier {
  int _bpm = 120;

  int get bpm => _bpm;

  void updateBpm(int value, bool isIncrement) {
    if (isIncrement) {
      _bpm += value;
    } else {
      _bpm = value;
    }
    notifyListeners();
  }
}
