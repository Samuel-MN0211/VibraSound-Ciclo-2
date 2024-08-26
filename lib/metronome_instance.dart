import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'bpm_setter.dart';
import 'package:metronomo_definitivo/value_setter.dart' as custom;
import 'metronome.dart';
import 'multiple_metronome_page.dart'; // Importar para acessar o estado
import 'package:torch_controller/torch_controller.dart';
import 'dart:collection'; // Import necessário para a Queue

class MetronomeInstance extends StatefulWidget {
  final Function? onStateChanged;

  const MetronomeInstance({Key? key, this.onStateChanged}) : super(key: key);

  @override
  MetronomeInstanceState createState() => MetronomeInstanceState();
}

class MetronomeInstanceState extends State<MetronomeInstance> {
  final TorchController _torchController = TorchController();
  late Metronome _metronome;
  int _bpm = 120;
  int _beatsPerMeasure = 4;
  int _clicksPerBeat = 3;
  bool _isPlaying = false;
  bool _isTorchOn = false;
  bool _isVibrating = true;
  Color _backgroundColor = Color(0xFF095169);
  Timer? _clickTimer;
  int _currentTick = 0;
  int _currentCycle = 0;
  int _currentBeat = 0;
  late Queue<AudioPlayer> _clickPlayers;
  late Queue<AudioPlayer> _specialClickPlayers;
  late Duration _clickDuration;
  late Duration _specialClickDuration;

  // Getters and Setters
  int get bpm => _bpm;
  set bpm(int value) {
    setState(() {
      _bpm = value;
    });
  }

  int get beatsPerMeasure => _beatsPerMeasure;
  set beatsPerMeasure(int value) {
    setState(() {
      _beatsPerMeasure = value;
    });
  }

  int get clicksPerBeat => _clicksPerBeat;
  set clicksPerBeat(int value) {
    setState(() {
      _clicksPerBeat = value;
    });
  }

  bool get isPlaying => _isPlaying;
  set isPlaying(bool value) {
    setState(() {
      _isPlaying = value;
      widget.onStateChanged?.call();
    });
  }

  bool get isTorchOn => _isTorchOn;
  set isTorchOn(bool value) {
    setState(() {
      _isTorchOn = value;
    });
  }

  bool get isVibrating => _isVibrating;
  set isVibrating(bool value) {
    setState(() {
      _isVibrating = value;
    });
  }

  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color value) {
    setState(() {
      _backgroundColor = value;
      widget.onStateChanged?.call(); // Notificar sobre a mudança de cor
    });
  }

  @override
  void initState() {
    super.initState();
    _metronome = Metronome(bpm: _bpm, clicksPerBeat: _clicksPerBeat);
    _metronome.onTick(_onTick);
    _preloadSounds();
  }

  void _preloadSounds() {
    _clickPlayers = Queue<AudioPlayer>.from(List.generate(
        10, (_) => AudioPlayer()..setSource(AssetSource('clique.wav'))));
    _specialClickPlayers = Queue<AudioPlayer>.from(List.generate(
        10, (_) => AudioPlayer()..setSource(AssetSource('tick.wav'))));

    _clickPlayers.first.onDurationChanged.listen((Duration d) {
      setState(() => _clickDuration = d);
    });

    _specialClickPlayers.first.onDurationChanged.listen((Duration d) {
      setState(() => _specialClickDuration = d);
    });
  }

  void _playSound(
      Queue<AudioPlayer> players, Duration duration, String audioFile) {
    final player = players.removeFirst();
    player.seek(Duration.zero);
    player.resume();

    Future.delayed(duration * 0.95, () {
      player.stop();
      players.addLast(AudioPlayer()..setSource(AssetSource(audioFile)));
    });
  }

  void _onTick() {
    _currentTick++;
    _currentBeat++;
    int interval = (60000 / (_bpm * _clicksPerBeat)).round();
    int vibrationDuration = interval ~/ 2;

    if (_currentTick % _clicksPerBeat == 1) {
      _currentCycle++;
      _currentBeat = 1;
      vibrationDuration = (interval * 0.8).round();
      _changeToBlack();
      _torchOn(_isTorchOn, vibrationDuration);
      _playSound(_specialClickPlayers, _specialClickDuration, 'tick.wav');
    } else {
      _torchOn(_isTorchOn, vibrationDuration);
      _playSound(_clickPlayers, _clickDuration, 'clique.wav');
      _changeToRandomColor();
    }

    _vibrateOn(_isVibrating, vibrationDuration);

    if (_currentCycle > _beatsPerMeasure) {
      _currentCycle = 1;
    }
  }

  void _changeToBlack() {
    setState(() {
      backgroundColor = Colors.black;
    });
  }

  void _vibrateOn(bool isVibratingOn, int vibrationDuration) {
    if (isVibratingOn) {
      Vibration.vibrate(duration: vibrationDuration);
    }
  }

  void _torchOn(bool isTorchOn, int vibrationDuration) {
    if (isTorchOn) {
      _torchController.toggle(intensity: 1);
      Future.delayed(Duration(milliseconds: vibrationDuration), () {
        _torchController.toggle();
      });
    }
  }

  void _changeToRandomColor() {
    setState(() {
      backgroundColor =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    });
  }

  void _toggleIsVibrateOn() {
    setState(() {
      _isVibrating = !_isVibrating;
    });
  }

  void _toggleIsTorchOn() {
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _metronome.stop();
        _currentTick = 0;
        _currentCycle = 0;
      } else {
        _metronome.setBPM(_bpm);
        _metronome.setClicksPerBeat(_clicksPerBeat);
        _metronome.start();
      }
      isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _metronome.dispose();
    _clickTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isPlaying
              ? SizedBox.shrink()
              : BpmSetter(
                  bpm: _bpm,
                  onBpmChanged: (newBpm) => bpm = newBpm,
                ),
          Container(
            height: 240,
            width: 240,
            decoration: BoxDecoration(
              color: _backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$_currentBeat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BellotaText',
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(12)),
          _isPlaying
              ? SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Compasso',
                          style: TextStyle(fontSize: 22),
                        ),
                        custom.ValueSetter(
                          value: _beatsPerMeasure,
                          onValueChanged: (newValue) =>
                              beatsPerMeasure = newValue,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Batidas', style: TextStyle(fontSize: 22)),
                        custom.ValueSetter(
                          value: _clicksPerBeat,
                          onValueChanged: (newValue) =>
                              clicksPerBeat = newValue,
                        ),
                      ],
                    ),
                  ],
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Positioned(
                child: IconButton(
                  onPressed: _toggleIsVibrateOn,
                  icon: _isPlaying
                      ? Icon(null)
                      : Icon(
                          Icons.vibration,
                          color: _isVibrating ? Colors.black : Colors.grey,
                        ),
                  iconSize: 36,
                ),
              ),
              IconButton(
                onPressed: _togglePlayPause,
                icon: Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                iconSize: 50,
              ),
              IconButton(
                onPressed: _toggleIsTorchOn,
                icon: _isPlaying
                    ? Icon(null)
                    : Icon(
                        _isTorchOn ? Icons.lightbulb : Icons.lightbulb_outline,
                        color: _isTorchOn ? Colors.black : Colors.grey,
                      ),
                iconSize: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
