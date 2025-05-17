import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

class Metronome {
  int bpm;
  int clicksPerBeat;
  int beatsPerMeasure;
  Timer? _timer;
  Function? _onTick;
  bool isPlaying = false;
  Color color = const Color(0xFF095169);
  int currentBeat;
  int currentCycle;

  Metronome({
    required this.bpm,
    this.clicksPerBeat = 1,
    this.beatsPerMeasure = 1,
    this.isPlaying = false,
    this.currentBeat = 0,
    this.currentCycle = 0,
  });

  get ifIsPlaying => isPlaying;
  get currentBpm => bpm;
  get currentClicksPerBeat => clicksPerBeat;
  get currentBeatsPerMeasure => beatsPerMeasure;
  get currentColor => color;
  get currentCycleValue => currentCycle;
  get currentBeatValue => currentBeat;

  void start() {
    if (isPlaying) return;
    isPlaying = true;
    int interval = (60000 / bpm).round();
    _timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      _onTick?.call();
    });
  }

  void stop() {
    _timer?.cancel();
    isPlaying = false;
  }

  void onTick(Function callback) {
    _onTick = callback;
  }

  void dispose() {
    _timer?.cancel();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bpm': bpm,
      'clicksPerBeat': clicksPerBeat,
      'beatsPerMeasure': beatsPerMeasure,
      'isPlaying': isPlaying,
      'currentBeat': currentBeat,
      'currentCycle': currentCycle,
    };
  }

  factory Metronome.fromMap(Map<String, dynamic> map) {
    return Metronome(
      bpm: map['bpm'] as int,
      clicksPerBeat: map['clicksPerBeat'] as int,
      beatsPerMeasure: map['beatsPerMeasure'] as int,
      isPlaying: map['isPlaying'] as bool,
      currentBeat: map['currentBeat'] as int,
      currentCycle: map['currentCycle'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Metronome.fromJson(String source) =>
      Metronome.fromMap(json.decode(source) as Map<String, dynamic>);
}
