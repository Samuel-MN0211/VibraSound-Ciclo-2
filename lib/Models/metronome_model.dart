import 'dart:async';

class Metronome {
  int bpm;
  int clicksPerBeat;
  Timer? _timer;
  Function? _onTick;
  bool _isPlaying = false;

  Metronome({required this.bpm, this.clicksPerBeat = 1});

  get isPlaying => _isPlaying;
  get currentBpm => bpm;
  get currentClicksPerBeat => clicksPerBeat;

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

  void onTick(Function callback) {
    _onTick = callback;
  }

  void dispose() {
    _timer?.cancel();
  }
}
