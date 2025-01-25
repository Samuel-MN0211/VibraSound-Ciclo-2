import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/metronome_model.dart';

class MetronomeController extends ChangeNotifier {
  Metronome _metronome =
      Metronome(bpm: 120, clicksPerBeat: 3, beatsPerMeasure: 4);

  int get bpm => _metronome.currentBpm;
  int get clicksPerBeat => _metronome.currentClicksPerBeat;
  int get beatsPerMeasure => _metronome.currentBeatsPerMeasure;
  bool get isPlaying => _metronome.isPlaying;

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

  void updateClicksPerBeat(int value) {
    _metronome.clicksPerBeat = value;
    notifyListeners();
  }

  void updateIsPlaying(bool value) {
    _metronome.isPlaying = value;
    notifyListeners();
  }

  void updateBeatsPerMeasure(int value) {
    _metronome.beatsPerMeasure = value;
    notifyListeners();
  }
}
