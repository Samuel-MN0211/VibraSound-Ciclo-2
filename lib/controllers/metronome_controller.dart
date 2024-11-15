// import 'dart:async';
// import 'dart:collection';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:metronomo_definitivo/models/metronome_model.dart';
// import 'package:provider/provider.dart';

// import '../models/bpm_scheduler_model.dart';

// class MetronomeController extends ChangeNotifier {
//   Metronome metronome = Metronome();

//   late Queue<AudioPlayer> _clickPlayers;
//   late Queue<AudioPlayer> _specialClickPlayers;
//   late Duration _clickDuration;
//   late Duration _specialClickDuration;
//   Function? _onTick;

//   void stopMetronome() {
//     metronome.timer?.cancel();
//   }

//   void startMetronome() {
//     if (metronome.isPlaying) return;
//     metronome.isPlaying = true;
//     int interval = (60000 / metronome.bpm).round();
//     metronome.timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
//       _onTick?.call();
//     });
//   }

//   void onTick(Function callback) {
//     _onTick = callback;
//   }

//   void preloadSounds() {
//     _clickPlayers = Queue<AudioPlayer>.from(List.generate(
//         10, (_) => AudioPlayer()..setSource(AssetSource('clique.wav'))));
//     _specialClickPlayers = Queue<AudioPlayer>.from(List.generate(
//         10, (_) => AudioPlayer()..setSource(AssetSource('tick.wav'))));

//     _clickPlayers.first.onDurationChanged.listen((Duration d) {
//       _clickDuration = d;
//       notifyListeners();
//     });

//     _specialClickPlayers.first.onDurationChanged.listen((Duration d) {
//       _specialClickDuration = d;
//       notifyListeners();
//     });
//   }

//   void playSound(
//       Queue<AudioPlayer> players, Duration duration, String audioFile) {
//     final player = players.removeFirst();
//     player.seek(Duration.zero);
//     player.resume();

//     Future.delayed(duration * 0.95, () {
//       player.stop();
//       players.addLast(AudioPlayer()..setSource(AssetSource(audioFile)));
//     });
//   }

//   void changeToBlack() {
//     metronome.backgroundColor = Colors.black;
//     notifyListeners();
//   }

//   void changeToRandomColor() {
//     if (metronome.backgroundColor == Colors.black) {
//       metronome.backgroundColor = Colors.green;
//     } else if (metronome.backgroundColor == Colors.green) {
//       metronome.backgroundColor = Colors.blue;
//     } else {
//       metronome.backgroundColor = Colors.green;
//     }
//     notifyListeners();
//   }

//   void updateBpm(int newValue) {
//     metronome = metronome.copyWith(bpm: newValue);
//     notifyListeners();
//   }

//   void updateCompasso(int newValue) {
//     metronome = metronome.copyWith(compasso: newValue);
//     notifyListeners();
//   }

//   void updateClicksPerBeat(int newValue) {
//     metronome = metronome.copyWith(clicksPerBeat: newValue);
//     notifyListeners();
//   }
// }
