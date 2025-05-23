import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/metronome_model.dart';
import 'package:metronomo_definitivo/Models/bpm_scheduler_model.dart';
import 'package:metronomo_definitivo/controllers/sound_controller.dart';
import 'package:metronomo_definitivo/controllers/torch_manager.dart';
import 'package:metronomo_definitivo/controllers/vibration_controller.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class MetronomeController extends ChangeNotifier {
  Metronome _metronome =
      Metronome(bpm: 120, clicksPerBeat: 3, beatsPerMeasure: 4);
  bool _bpmHasChanged = false;

  late SoundController soundController;
  late VibrationController vibrationController;
  late TorchManager torchManager;
  late BpmSchedulerModel bpmScheduler;

  final WatchConnectivity _watch = WatchConnectivity();

  MetronomeController(
      {required this.soundController,
      required this.vibrationController,
      required this.torchManager,
      required this.bpmScheduler});

  MetronomeController.smartWatch();

  int get bpm => _metronome.currentBpm;
  int get clicksPerBeat => _metronome.currentClicksPerBeat;
  int get beatsPerMeasure => _metronome.currentBeatsPerMeasure;
  bool get isPlaying => _metronome.isPlaying;
  Color get color => _metronome.currentColor;
  int get currentCycle => _metronome.currentCycleValue;
  int get currentBeat => _metronome.currentBeatValue;
  bool get bpmHasChanged => _bpmHasChanged;

  void start() {
    _metronome.start();
    _metronome.onTick(_onTick);
    sendDataToWatch();
    notifyListeners();
  }

  void stop() {
    _metronome.stop();
    sendDataToWatch();
    notifyListeners();
  }

  int calcInterval() {
    return (60000 / (_metronome.bpm * _metronome.clicksPerBeat)).round();
  }

  void _onTickSmartWatch() {
    updateCurrentBeat(_metronome.currentBeat + 1);

    int interval = calcInterval();
    int vibrationDuration = interval ~/ 2;

    if (_bpmHasChanged) {
      restartMetronome();
      resetChangeFlag();
    }

    if (_metronome.currentBeat % _metronome.clicksPerBeat == 1 ||
        _metronome.clicksPerBeat == 1) {
      updateCurrentCycle(_metronome.currentCycle + 1);
      updateCurrentBeat(1);
      vibrationDuration = (interval * 0.8).round();
    }

    vibrationController.vibrate(vibrationDuration);

    if (_metronome.currentCycle > _metronome.beatsPerMeasure) {
      updateCurrentCycle(1);
    }
  }

  void _onTick() {
    updateCurrentBeat(_metronome.currentBeat + 1);

    int interval = calcInterval();
    int vibrationDuration = interval ~/ 2;

    if (bpmScheduler.isActivated) {
      final now = DateTime.now();
      if (now.difference(bpmScheduler.lastChange).inSeconds >=
          bpmScheduler.secondsToMakeChange) {
        updateBpm(_metronome.bpm + bpmScheduler.valueToChange);
        bpmScheduler.lastChange = now;

        restartMetronome();
      }
    }

    if (_bpmHasChanged) {
      restartMetronome();
      resetChangeFlag();
    }

    if (_metronome.currentBeat % _metronome.clicksPerBeat == 1 ||
        _metronome.clicksPerBeat == 1) {
      updateCurrentCycle(_metronome.currentCycle + 1);
      updateCurrentBeat(1);
      vibrationDuration = (interval * 0.8).round();
      changeToBlack();
      torchManager.torchOn(vibrationDuration);
      soundController.playSpecialClick();
    } else {
      torchManager.torchOn(vibrationDuration);
      soundController.playClick();
      changeToRandomColor();
    }

    vibrationController.vibrate(vibrationDuration);

    if (_metronome.currentCycle > _metronome.beatsPerMeasure) {
      updateCurrentCycle(1);
    }
    sendDataToWatch();
  }

  void restartMetronome() {
    stop();
    newMetronome();
    start();
  }

  void newMetronome() {
    _metronome = Metronome(
      bpm: bpm,
      clicksPerBeat: clicksPerBeat,
      beatsPerMeasure: beatsPerMeasure,
      isPlaying: isPlaying,
    );
    notifyListeners();
  }

  void updateBpm(int value) {
    _metronome.bpm = value;
    sendDataToWatch();
    notifyListeners();
  }

  void updateBpmWhileIsPlaying(int value) {
    _metronome.bpm = value;
    _bpmHasChanged = true;
    notifyListeners();
  }

  void resetChangeFlag() {
    _bpmHasChanged = false;
  }

  void updateClicksPerBeat(int value) {
    _metronome.clicksPerBeat = value.clamp(1, 8);
    sendDataToWatch();
    notifyListeners();
  }

  void updateCurrentBeat(int value) {
    _metronome.currentBeat = value;
    sendDataToWatch();
    notifyListeners();
  }

  void updateCurrentCycle(int value) {
    _metronome.currentCycle = value;
    sendDataToWatch();
    notifyListeners();
  }

  void updateBeatsPerMeasure(int value) {
    _metronome.beatsPerMeasure = value.clamp(1, 8);
    sendDataToWatch();
    notifyListeners();
  }

  void changeToBlack() {
    _metronome.color = Colors.black;
  }

  void changeToRandomColor() {
    if (_metronome.color == Colors.black) {
      _metronome.color = Colors.green;
    } else if (_metronome.color == Colors.green) {
      _metronome.color = Colors.blue;
    } else {
      _metronome.color = Colors.green;
    }
  }

  void sendDataToWatch() {
    final message = _metronome.toMap();
    _watch.sendMessage(message);
  }
}
