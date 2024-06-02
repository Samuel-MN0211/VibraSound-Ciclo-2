import 'dart:async';

class Metronome {
  int bpm;
  Timer? _timer;
  Function? _onTick;
  bool _isPlaying = false;

  Metronome({this.bpm = 120});

  void start() {
    if (_isPlaying) return;
    _isPlaying = true;
    _timer = Timer.periodic(Duration(milliseconds: 60000 ~/ bpm), (_) {
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
