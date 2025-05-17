import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:metronomo_definitivo/controllers/watch_metronome_controller.dart';
import 'package:provider/provider.dart';

class ActiveComponent extends StatefulWidget {
  const ActiveComponent({super.key});

  @override
  State<ActiveComponent> createState() => _ActiveComponentState();
}

class _ActiveComponentState extends State<ActiveComponent>
    with SingleTickerProviderStateMixin {
  late WatchMetronomeController _controller;
  Ticker? _ticker;
  bool _isVibrating = true;
  int _lastBpm = 0;
  int _lastClicksPerBeat = 0;

  int _lastTickTime = 0;
  int _tickInterval = 1000; // Padrão 1 segundo
  int _tickCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = Provider.of<WatchMetronomeController>(context, listen: false);
    _controller.addListener(_onControllerUpdate);

    _ticker = createTicker(_onTick);

    if (_isVibrating) {
      _startVibrationTicker();
    }
  }

  void _onControllerUpdate() {
    if (_controller.metronome != null &&
        (_lastBpm != _controller.metronome!.bpm ||
            _lastClicksPerBeat != _controller.metronome!.clicksPerBeat)) {
      _lastBpm = _controller.metronome!.bpm;
      _lastClicksPerBeat = _controller.metronome!.clicksPerBeat;

      _updateTickInterval();

      _tickCount = 0;
      _lastTickTime = DateTime.now().millisecondsSinceEpoch;

      if (_isVibrating && _ticker != null && !_ticker!.isTicking) {
        _startVibrationTicker();
      }
    }
  }

  void _updateTickInterval() {
    if (_controller.metronome != null) {
      _tickInterval = (60000 /
              (_controller.metronome!.bpm *
                  _controller.metronome!.clicksPerBeat))
          .round();
      print(
          "Novo intervalo calculado: $_tickInterval ms (BPM: ${_controller.metronome!.bpm})");
    }
  }

  void _onTick(Duration elapsed) {
    if (!_isVibrating || _controller.metronome == null) return;

    int now = DateTime.now().millisecondsSinceEpoch;
    int elapsed = now - _lastTickTime;

    if (elapsed >= _tickInterval) {
      _controller.vibrate();
      _lastTickTime = now;
      _tickCount++;
    }
  }

  void _startVibrationTicker() {
    _updateTickInterval();
    _lastTickTime = DateTime.now().millisecondsSinceEpoch;
    _tickCount = 0;
    _ticker?.start();

    setState(() {
      _isVibrating = true;
    });
  }

  void _stopVibrationTicker() {
    _ticker?.stop();
    setState(() {
      _isVibrating = false;
    });
  }

  void _toggleVibration() {
    if (_isVibrating) {
      _stopVibrationTicker();
    } else {
      _startVibrationTicker();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchMetronomeController>(
      builder: (context, controller, child) {
        if (controller.metronome == null) {
          return const Scaffold(
            body: Center(
              child: Text('Aguardando dados do metronome...'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: controller.metronome!.color,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BPM: ${controller.metronome!.bpm}',
                  style: const TextStyle(fontSize: 32),
                ),
                Text(
                  'Batida: ${controller.metronome!.currentBeat}/${controller.metronome!.clicksPerBeat}',
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  'Compasso: ${controller.metronome!.currentCycle}/${controller.metronome!.beatsPerMeasure}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: _toggleVibration,
                  icon: Icon(
                    Icons.vibration,
                    size: 36,
                    color: _isVibrating ? Colors.white : Colors.grey,
                  ),
                ),
                Text(
                  _isVibrating ? 'Vibração ON' : 'Vibração OFF',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isVibrating ? Colors.white : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
