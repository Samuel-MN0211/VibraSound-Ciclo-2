import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'metronome.dart';
import 'multiple_metronome_page.dart'; // Importar para acessar o estado
import 'package:torch_controller/torch_controller.dart';
import 'dart:collection'; // Import necessário para a Queue

class MetronomeInstance extends StatefulWidget {
  const MetronomeInstance({Key? key}) : super(key: key);

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
    int interval = (60000 / (_bpm * _clicksPerBeat)).round();
    int vibrationDuration = interval ~/ 2;

    if (_currentTick % _clicksPerBeat == 1) {
      _currentCycle++;
      _changeToBlack();
      vibrationDuration = (interval * 0.8).round();
      _torchOn(_isTorchOn, vibrationDuration);
      _playSound(_specialClickPlayers, _specialClickDuration, 'tick.wav');
    } else {
      _changeToRandomColor();
      _torchOn(_isTorchOn, vibrationDuration);
      _playSound(_clickPlayers, _clickDuration, 'clique.wav');
    }

    _vibrateOn(_isVibrating, vibrationDuration);

    if (_currentCycle > _beatsPerMeasure) {
      _currentCycle = 1;
    }
  }

  void _changeToBlack() {
    setState(() {
      _backgroundColor = Colors.black;
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
      _backgroundColor =
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
      _isPlaying = !_isPlaying;
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
          BpmSetter(
            bpm: _bpm,
            onBpmChanged: (newBpm) => bpm = newBpm,
          ),
          Container(
              height: 240,
              width: 240,
              decoration: BoxDecoration(
                color: _backgroundColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1),
              )),
          Padding(padding: EdgeInsets.all(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Compasso',
                    style: TextStyle(fontSize: 22),
                  ),
                  ValueSetter(
                    value: _beatsPerMeasure,
                    onValueChanged: (newValue) => beatsPerMeasure = newValue,
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Batidas', style: TextStyle(fontSize: 22)),
                  ValueSetter(
                    value: _clicksPerBeat,
                    onValueChanged: (newValue) => clicksPerBeat = newValue,
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
                  icon: Icon(
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
                icon: Icon(
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

class ValueSetter extends StatefulWidget {
  final int value;
  final ValueChanged<int> onValueChanged;

  ValueSetter({required this.value, required this.onValueChanged});

  @override
  _ValueSetterState createState() => _ValueSetterState();
}

class _ValueSetterState extends State<ValueSetter> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => setState(() {
            _currentValue -= 1;
            widget.onValueChanged(_currentValue);
          }),
          icon: Icon(Icons.remove),
          iconSize: 28,
        ),
        Container(
          child: Text(
            '$_currentValue',
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'BellotaText',
            ),
          ),
        ),
        IconButton(
          onPressed: () => setState(() {
            _currentValue += 1;
            widget.onValueChanged(_currentValue);
          }),
          icon: Icon(Icons.add),
          iconSize: 25,
        ),
      ],
    );
  }
}

class BpmSetter extends StatefulWidget {
  final int bpm;
  final ValueChanged<int> onBpmChanged;

  BpmSetter({required this.bpm, required this.onBpmChanged});

  @override
  _BpmSetterState createState() => _BpmSetterState();
}

class _BpmSetterState extends State<BpmSetter> {
  late int _bpm;

  @override
  void initState() {
    super.initState();
    _bpm = widget.bpm;
  }

  void _updateBpm(int value) {
    setState(() {
      _bpm += value;
      widget.onBpmChanged(_bpm);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(70.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _updateBpm(-1),
                icon: Icon(Icons.remove),
                iconSize: 48,
              ),
              Container(
                child: Text(
                  '$_bpm',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 58,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BellotaText',
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _updateBpm(1),
                icon: Icon(Icons.add),
                iconSize: 48,
              ),
            ],
          ),
        ),
        Positioned(
          top: 35,
          right: 45,
          child: GestureDetector(
            onTap: () => _updateBpm(10),
            child: Container(
              width: 55,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '+10',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 35,
          left: 45,
          child: GestureDetector(
            onTap: () => _updateBpm(-10),
            child: Container(
              width: 55,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '-10',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 35,
          right: 45,
          child: GestureDetector(
            onTap: () => _updateBpm(5),
            child: Container(
              width: 55,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '+5',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 35,
          left: 45,
          child: GestureDetector(
            onTap: () => _updateBpm(-5),
            child: Container(
              width: 55,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '-5',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 45,
          child: Text('BPM', style: TextStyle(color: Colors.black)),
        )
      ],
    );
  }
}
