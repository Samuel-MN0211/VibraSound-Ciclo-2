import 'package:flutter/material.dart';

class IsPlayingModel with ChangeNotifier {
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  set isPlaying(bool value) {
    if (_isPlaying != value) {
      _isPlaying = value;
      notifyListeners();
    }
  }
}
