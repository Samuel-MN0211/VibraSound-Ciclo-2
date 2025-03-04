import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class ActiveComponent extends StatefulWidget {
  const ActiveComponent({super.key});

  @override
  State<ActiveComponent> createState() => _ActiveComponentState();
}

class _ActiveComponentState extends State<ActiveComponent> {
  final _watch = WatchConnectivity();
  int _bpm = 0;

  @override
  void initState() {
    super.initState();

    _watch.messageStream.listen((message) {
      if (message.containsKey('bpm')) {
        setState(() {
          _bpm = message['bpm'];
        });
      }
    });

    _watch.contextStream.listen((context) {
      if (context.containsKey('bpm')) {
        setState(() {
          _bpm = context['bpm'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'BPM: $_bpm',
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
