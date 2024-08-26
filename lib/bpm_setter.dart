import 'package:flutter/material.dart';

import 'metronome_instance.dart';

class BpmSetter extends StatefulWidget {
  final int bpm;
  final ValueChanged<int> onBpmChanged;

  BpmSetter({required this.bpm, required this.onBpmChanged});

  @override
  _BpmSetterState createState() => _BpmSetterState();
}

class _BpmSetterState extends State<BpmSetter> {
  late int _bpm;

  final GlobalKey<MetronomeInstanceState> _metronomeKey =
      GlobalKey<MetronomeInstanceState>();
  bool _isPlaying = false;

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
          padding: const EdgeInsets.fromLTRB(20, 70, 20, 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isPlaying
                  ? Icon(null)
                  : IconButton(
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
          right: 50,
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
