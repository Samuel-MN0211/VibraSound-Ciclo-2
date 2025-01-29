import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class VibrationController extends ChangeNotifier {
  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;
  void toggleVibration() {
    _isEnabled = !_isEnabled;
  }

  void vibrate(int duration) {
    if (_isEnabled) {
      Vibration.vibrate(duration: duration);
    }
  }
}
