import 'dart:async';

class Metronome {
  int bpm;
  int clicksPerBeat;
  Timer? _timer;
  Function? _onTick;
  bool _isPlaying = false;

  Metronome({required this.bpm, this.clicksPerBeat = 1});

  void start() {
    if (_isPlaying) return;
    _isPlaying = true;
    int interval = (60000 / bpm).round();
    _timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      _onTick?.call();
    });
  }

  void stop() {
    _timer?.cancel();
    _isPlaying = false;
  }

  void setBPM(int newBpm) {
    bpm = newBpm;
    if (_isPlaying) {
      stop();
      start();
    }
  }

  void setClicksPerBeat(int clicks) {
    clicksPerBeat = clicks;
  }

  void onTick(Function callback) {
    _onTick = callback;
  }

  bool isPlaying() {
    return _isPlaying;
  }

  void dispose() {
    _timer?.cancel();
  }
}
