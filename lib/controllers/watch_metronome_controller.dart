import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/metronome_model.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:vibration/vibration.dart';

class WatchMetronomeController extends ChangeNotifier {
  Metronome? _metronome;
  final WatchConnectivity _watch = WatchConnectivity();

  WatchMetronomeController() {
    _initializeWatch();
  }

  Metronome? get metronome => _metronome;

  void _initializeWatch() {
    _watch.messageStream.listen((message) {
      if (message.containsKey('bpm')) {
        try {
          _metronome = Metronome.fromMap(message);
          notifyListeners();
        } catch (e) {
          print('Erro ao reconstruir metronome: $e');
        }
      }
    });
  }

  void vibrate() async {
    if (_metronome == null) return;
    if (_metronome!.bpm <= 0 || _metronome!.clicksPerBeat <= 0) return;
    bool hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;
    try {
      int interval =
          (60000 / (_metronome!.bpm * _metronome!.clicksPerBeat)).round();
      int vibrationDuration = (interval * 0.8).round().clamp(50, 1000);

      Vibration.vibrate(duration: vibrationDuration);
    } catch (e) {
      print('Erro ao executar vibração: $e');
    }
  }
}
