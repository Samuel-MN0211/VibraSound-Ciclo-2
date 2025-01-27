import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/metronome_model.dart';

class MetronomeController extends ChangeNotifier {
  Metronome _metronome =
      Metronome(bpm: 120, clicksPerBeat: 3, beatsPerMeasure: 4);

  bool _bpmHasChanged = false;

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
    notifyListeners();
  }

  void stop() {
    _metronome.stop();
    notifyListeners();
  }

  void onTick(Function callback) {
    _metronome.onTick(() {
      callback();
      notifyListeners();
    });
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
    notifyListeners();
  }

  void updateCurrentBeat(int value) {
    _metronome.currentBeat = value;
    notifyListeners();
  }

  void updateCurrentCycle(int value) {
    _metronome.currentCycle = value;
    notifyListeners();
  }

  void updateIsPlaying(bool value) {
    _metronome.isPlaying = value;
    notifyListeners();
  }

  void updateBeatsPerMeasure(int value) {
    _metronome.beatsPerMeasure = value.clamp(1, 8);
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
}
