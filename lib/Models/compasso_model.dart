import 'package:flutter/material.dart';

class CompassoModel extends ChangeNotifier {
  int _compasso = 4;

  int get compasso => _compasso;

  void updateCompasso(int value, bool isIncrement) {
    if (isIncrement) {
      _compasso += value;
    } else {
      _compasso = value;
    }
    notifyListeners();
  }
}
