import 'package:flutter/material.dart';

class BpmModel extends ChangeNotifier {
  int _bpm = 120;
  final int _bpmMax = 240;
  final int _bpmMin = 40;
  bool _hasChanged = false;

  bool get hasChanged => _hasChanged;
  int get bpm => _bpm;

  void updateBpm(int value, bool isIncrement) {
    if (!isIncrement) {
      _bpm = value;
      return;
    }
    if (_bpm + value > _bpmMax) {
      _bpm = _bpmMax;
      return;
    }
    if (_bpm + value < _bpmMin) {
      _bpm = _bpmMin;
      return;
    }
    _hasChanged = true;
    _bpm += value;
    notifyListeners();
  }

  void resetChangeFlag() {
    _hasChanged = false;
  }
}
