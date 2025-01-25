import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/metronome_model.dart';

class MetronomeController extends ChangeNotifier {
  Metronome _metronome = Metronome(bpm: 120);

  get bpm => _metronome.currentBpm;
  get clicksPerBeat => _metronome.currentClicksPerBeat;
  get isPlaying => _metronome.isPlaying;

  void start() {
    _metronome.start();
    notifyListeners();
  }

  void stop() {
    _metronome.stop();
    notifyListeners();
  }

  void onTick(Function callback) {
    _metronome.onTick(callback);
  }

  void newMetronome(int bpm, int clicksPerBeat) {
    _metronome = Metronome(bpm: _metronome.bpm, clicksPerBeat: clicksPerBeat);
    notifyListeners();
  }

  void updateBpm(int value) {
    _metronome.bpm = value;
    notifyListeners();
  }

  void updateClicksPerBeat(int value) {
    _metronome.clicksPerBeat = value;
    notifyListeners();
  }
}
