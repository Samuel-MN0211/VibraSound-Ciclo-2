import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:vibration/vibration.dart';
import 'metronome.dart';
import 'multiple_metronome_page.dart'; // Importar para acessar o estado

class MetronomeInstance extends StatefulWidget {
  const MetronomeInstance({Key? key}) : super(key: key);

  @override
  MetronomeInstanceState createState() => MetronomeInstanceState();
}

class MetronomeInstanceState extends State<MetronomeInstance> {
  late Metronome _metronome;
  int _bpm = 120;
  int _beatsPerMeasure = 4;
  int _clicksPerBeat = 3;
  bool _isPlaying = false;
  Color _backgroundColor = Colors.white;
  Timer? _clickTimer;
  int _currentTick = 0;
  int _currentCycle = 0;

  @override
  void initState() {
    super.initState();
    _metronome = Metronome(bpm: _bpm, clicksPerBeat: _clicksPerBeat);
    _metronome.onTick(_onTick);
  }

  void _onTick() {
    _currentTick++;
    int interval = (60000 / (_bpm * _clicksPerBeat)).round();
    int vibrationDuration = interval ~/ 2;

    if (_currentTick % _clicksPerBeat == 1) {
      _currentCycle++;
      _changeToBlack();
      vibrationDuration = (interval * 0.8).round();
    } else {
      _changeToRandomColor();
    }

    Vibration.vibrate(duration: vibrationDuration);

    if (_currentCycle > _beatsPerMeasure) {
      _currentCycle = 1;
    }
  }

  void _changeToBlack() {
    setState(() {
      _backgroundColor = Colors.black;
    });
  }

  void _changeToRandomColor() {
    setState(() {
      _backgroundColor =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
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
    return Stack(
      children: [
        Container(
          color: _backgroundColor,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Text('BPM: $_bpm',
                  style: TextStyle(
                      color: _backgroundColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white)),
              Slider(
                value: _bpm.toDouble(),
                min: 30,
                max: 300,
                divisions: 270,
                onChanged: (value) {
                  setState(() {
                    _bpm = value.toInt();
                    if (_isPlaying) {
                      _metronome.setBPM(_bpm);
                    }
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<int>(
                    value: _beatsPerMeasure,
                    items: List.generate(12, (index) => index + 1)
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value Beats'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _beatsPerMeasure = newValue!;
                      });
                    },
                  ),
                  DropdownButton<int>(
                    value: _clicksPerBeat,
                    items: List.generate(8, (index) => index + 1)
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value Clicks'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _clicksPerBeat = newValue!;
                        if (_isPlaying) {
                          _metronome.setClicksPerBeat(_clicksPerBeat);
                        }
                      });
                    },
                  ),
                ],
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => (context as Element)
                    .findAncestorStateOfType<MultipleMetronomePageState>()
                    ?.removeMetronome(widget.key!),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            child: Text(
              '$_currentCycle',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
