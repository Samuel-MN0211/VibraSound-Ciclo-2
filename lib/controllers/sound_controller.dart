import 'package:audioplayers/audioplayers.dart';
import 'dart:collection';

import 'package:flutter/material.dart';

class SoundController extends ChangeNotifier {
  final Queue<AudioPlayer> _clickPlayers = Queue<AudioPlayer>();
  final Queue<AudioPlayer> _specialClickPlayers = Queue<AudioPlayer>();

  void preloadSounds() {
    _clickPlayers.addAll(List.generate(
        10, (_) => AudioPlayer()..setSource(AssetSource('clique.wav'))));
    _specialClickPlayers.addAll(List.generate(
        10, (_) => AudioPlayer()..setSource(AssetSource('tick.wav'))));
  }

  void playSound(Queue<AudioPlayer> players, String audioFile) {
    if (players.isEmpty) return;
    final player = players.removeFirst();
    player.seek(Duration.zero);
    player.resume();
    players.addLast(AudioPlayer()..setSource(AssetSource(audioFile)));
  }

  void playClick() {
    playSound(_clickPlayers, 'clique.wav');
  }

  void playSpecialClick() {
    playSound(_specialClickPlayers, 'tick.wav');
  }
}
