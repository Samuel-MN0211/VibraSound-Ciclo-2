import 'dart:async';

class Metronome {
  int bpm;
  int clicksPerBeat;
  int beatsPerMeasure;
  Timer? _timer;
  Function? _onTick;
  bool isPlaying = false;

  Metronome(
      {required this.bpm,
      this.clicksPerBeat = 1,
      this.beatsPerMeasure = 1,
      this.isPlaying = false});

  get ifIsPlaying => isPlaying;
  get currentBpm => bpm;
  get currentClicksPerBeat => clicksPerBeat;
  get currentBeatsPerMeasure => beatsPerMeasure;

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
}
