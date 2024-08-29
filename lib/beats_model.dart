import 'package:flutter/material.dart';

class BeatsModel extends ChangeNotifier {
  int _beats = 3;

  int get beats => _beats;

  void updateBeats(int value, bool isIncrement) {
    if (isIncrement) {
      _beats += value;
    } else {
      _beats = value;
    }
    notifyListeners();
  }
}
