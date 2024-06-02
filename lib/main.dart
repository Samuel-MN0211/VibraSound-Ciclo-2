import 'metronome.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MetronomeApp());
}

class MetronomeApp extends StatelessWidget {
  const MetronomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/multiple_metronomes': (context) => const MultipleMetronomePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metronome App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/multiple_metronomes');
          },
          child: const Text('Go to Multiple Metronomes'),
        ),
      ),
    );
  }
}

class MultipleMetronomePage extends StatefulWidget {
  const MultipleMetronomePage({super.key});

  @override
  MultipleMetronomePageState createState() => MultipleMetronomePageState();
}

class MultipleMetronomePageState extends State<MultipleMetronomePage> {
  List<MetronomeInstance> _metronomes = [];

  @override
  void initState() {
    super.initState();
    _addMetronome();
  }

  void _addMetronome() {
    setState(() {
      _metronomes.add(MetronomeInstance(key: UniqueKey()));
    });
  }

  void _removeMetronome(Key key) {
    setState(() {
      _metronomes.removeWhere((element) => element.key == key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple Metronomes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMetronome,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _metronomes.length,
        itemBuilder: (context, index) {
          return _metronomes[index];
        },
      ),
    );
  }
}

class MetronomeInstance extends StatefulWidget {
  const MetronomeInstance({Key? key}) : super(key: key);

  @override
  MetronomeInstanceState createState() => MetronomeInstanceState();
}

class MetronomeInstanceState extends State<MetronomeInstance> {
  late Metronome _metronome;
  int _bpm = 120;
  int _beatsPerMeasure = 4;
  int _clicksPerBeat = 1;
  bool _isPlaying = false;
  Color _backgroundColor = Colors.white;
  Timer? _clickTimer;

  @override
  void initState() {
    super.initState();
    _metronome = Metronome(bpm: _bpm);
    _metronome.onTick(_onTick);
  }

  void _onTick() {
    _changeToBlack();
    _scheduleClicks();
  }

  void _changeToBlack() {
    setState(() {
      _backgroundColor = Colors.black;
    });
  }

  void _scheduleClicks() {
    _clickTimer?.cancel();
    int interval = (60000 / (_bpm * _clicksPerBeat)).round();
    for (int i = 1; i < _clicksPerBeat; i++) {
      Future.delayed(
          Duration(milliseconds: interval * i), _changeToRandomColor);
    }
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
      } else {
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
    return Container(
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
                _metronome.setBPM(_bpm);
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
                ?._removeMetronome(widget.key!),
          ),
        ],
      ),
    );
  }
}
