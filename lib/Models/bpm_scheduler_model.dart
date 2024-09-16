import 'package:flutter/material.dart';

class BpmSchedulerModel extends ChangeNotifier {
  bool _isActivated = false;
  late bool _isIncrease;
  late int _valueToChange;
  late int _secondsToMakeChange;
  late DateTime _lastChange;

  bool get isIncrease => _isIncrease;
  int get valueToChange => _valueToChange;
  int get secondsToMakeChange => _secondsToMakeChange;
  bool get isActivated => _isActivated;
  DateTime get lastChange => _lastChange;
  set lastChange(DateTime value) {
    _lastChange = value;
  }

  void activeScheduler(
      int valueToChange, int secondsToMakeChange, bool isIncrease) {
    _isActivated = true;
    _valueToChange = valueToChange;
    _secondsToMakeChange = secondsToMakeChange;
    _isIncrease = isIncrease;
    notifyListeners();
  }

  void desactiveScheduler() {
    _isActivated = false;
    notifyListeners();
  }
}
