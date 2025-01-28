import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/genre_selected_model.dart';
import 'package:metronomo_definitivo/Widgets/ticks_compasso.dart';
import 'package:metronomo_definitivo/controllers/metronome_controller.dart';
import 'package:metronomo_definitivo/controllers/sound_controller.dart';
import 'package:metronomo_definitivo/controllers/torch_manager.dart';
import 'package:metronomo_definitivo/controllers/vibration_controller.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../Models/bpm_scheduler_model.dart';
import 'bpm_setter.dart';

class MetronomeInstance extends StatefulWidget {
  final Function? onStateChanged;

  const MetronomeInstance({Key? key, this.onStateChanged}) : super(key: key);

  @override
  MetronomeInstanceState createState() => MetronomeInstanceState();
}

class MetronomeInstanceState extends State<MetronomeInstance> {
  Timer? _clickTimer;
  int timerRunning = 0;
  Timer? _timer;

  late MetronomeController metronome;
  late SoundController soundController;
  late VibrationController vibrationController;
  late TorchManager torchManager;

  @override
  void initState() {
    super.initState();
    metronome = Provider.of<MetronomeController>(context, listen: false);
    soundController = Provider.of<SoundController>(context, listen: false);
    vibrationController =
        Provider.of<VibrationController>(context, listen: false);
    torchManager = Provider.of<TorchManager>(context, listen: false);
    soundController.preloadSounds();
  }

  void _onTick() {
    setState(() {
      metronome.updateCurrentBeat(metronome.currentBeat + 1);
    });

    final bpmScheduler = Provider.of<BpmSchedulerModel>(context, listen: false);

    int interval = (60000 / (metronome.bpm * metronome.clicksPerBeat)).round();
    int vibrationDuration = interval ~/ 2;

    if (bpmScheduler.isActivated) {
      final now = DateTime.now();
      if (now.difference(bpmScheduler.lastChange).inSeconds >=
          bpmScheduler.secondsToMakeChange) {
        metronome.updateBpm(metronome.bpm + bpmScheduler.valueToChange);
        bpmScheduler.lastChange = now;

        metronome.stop();
        metronome.newMetronome();
        metronome.onTick(_onTick);
        metronome.start();

        interval = (60000 / (metronome.bpm * metronome.clicksPerBeat)).round();
        vibrationDuration = interval ~/ 2;
      }
    }

    if (metronome.bpmHasChanged) {
      metronome.stop();
      metronome.newMetronome();
      metronome.onTick(_onTick);
      metronome.start();

      interval = (60000 / (metronome.bpm * metronome.clicksPerBeat)).round();
      vibrationDuration = interval ~/ 2;
      metronome.resetChangeFlag();
    }

    if (metronome.currentBeat % metronome.clicksPerBeat == 1 ||
        metronome.clicksPerBeat == 1) {
      setState(() {
        metronome.updateCurrentCycle(metronome.currentCycle + 1);
        metronome.updateCurrentBeat(1);
      });
      vibrationDuration = (interval * 0.8).round();
      metronome.changeToBlack();
      torchManager.torchOn(vibrationDuration);
      soundController.playSpecialClick();
    } else {
      torchManager.torchOn(vibrationDuration);
      soundController.playClick();
      metronome.changeToRandomColor();
    }

    vibrationController.vibrate(vibrationDuration);

    if (metronome.currentCycle > metronome.beatsPerMeasure) {
      metronome.updateCurrentCycle(1);
    }
  }

  void _toggleIsVibrateOn() {
    setState(() {
      vibrationController.toggleVibration();
    });
  }

  void _toggleIsTorchOn() {
    setState(() {
      torchManager.toggleTorch();
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _timerRunning() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timerRunning++;
      });
    });
  }

  void _togglePlayPause() {
    final bpmScheduler = Provider.of<BpmSchedulerModel>(context, listen: false);
    setState(() {
      if (metronome.isPlaying) {
        metronome.stop();
        metronome.updateCurrentCycle(0);
        metronome.updateCurrentBeat(0);
        timerRunning = 0;
        _timer?.cancel();
        bpmScheduler.desactiveScheduler();
      } else {
        if (bpmScheduler.isActivated) {
          bpmScheduler.lastChange = DateTime.now();
        }
        metronome.newMetronome();
        metronome.onTick(_onTick);
        metronome.start();
        _timerRunning();
      }
    });
  }

  @override
  void dispose() {
    _clickTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenHeight = mediaQuery.size.height;

    final double spaceSize = screenHeight * 0.03;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(spaceSize),
          ),
          BpmSetter(),
          Padding(
            padding: EdgeInsets.all(spaceSize - 13),
          ),
          _circle(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_runningTimer(), _genreSelect()],
          ),
          metronome.isPlaying
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [_beatsPerMeasure()],
                    ),
                    Column(
                      children: [_clickPerBeats()],
                    ),
                  ],
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              metronome.isPlaying ? const SizedBox.shrink() : _toggleVibrate(),
              _togglePlay(),
              metronome.isPlaying ? const SizedBox.shrink() : _toggleTorch()
            ],
          ),
          _beatsPerMeasureSwitcher(),
        ],
      ),
    );
  }

  Widget _circle() {
    return Consumer<MetronomeController>(
      builder: (context, metronome, child) {
        return Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: metronome.color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${metronome.currentBeat}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _runningTimer() {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0),
      child: Text(
        _formatTime(timerRunning),
        style: TextStyle(fontSize: screenWidth * 0.04),
      ),
    );
  }

  Widget _genreSelect() {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final GenreSelectedModel genreSelectedModel =
        Provider.of<GenreSelectedModel>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0),
      child: Container(
        margin: EdgeInsets.only(right: screenWidth * 0.08),
        child: Text(
          genreSelectedModel.genreSelected,
          style: TextStyle(fontSize: screenWidth * 0.04),
        ),
      ),
    );
  }

  Widget _beatsPerMeasure() {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    return Column(
      children: [
        Text(
          'Compasso',
          style: TextStyle(fontSize: screenWidth * 0.05),
        ),
        _beatsPerMeasureSetter()
      ],
    );
  }

  Widget _clickPerBeats() {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    return Column(
      children: [
        Text('Batidas', style: TextStyle(fontSize: screenWidth * 0.05)),
        _clicksPerBeatSetter()
      ],
    );
  }

  Widget _toggleVibrate() {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    return IconButton(
      onPressed: _toggleIsVibrateOn,
      icon: Icon(
        Icons.vibration,
        color: vibrationController.isEnabled ? Colors.black : Colors.grey,
      ),
      iconSize: screenWidth * 0.1,
    );
  }

  Widget _togglePlay() {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    return IconButton(
      onPressed: () {
        _togglePlayPause();
      },
      icon: Container(
        height: screenWidth * 0.2,
        width: screenWidth * 0.2,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Icon(
          metronome.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _toggleTorch() {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    return IconButton(
      onPressed: _toggleIsTorchOn,
      icon: Icon(
        Icons.flashlight_on,
        color: torchManager.isTorchOn ? Colors.black : Colors.grey,
      ),
      iconSize: screenWidth * 0.1,
    );
  }

  Widget _beatsPerMeasureSwitcher() {
    return Consumer<MetronomeController>(
        builder: (context, metronome, child) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: metronome.isPlaying
                  ? Expanded(
                      child: Row(
                        key: ValueKey<int>(metronome.beatsPerMeasure),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          metronome.beatsPerMeasure,
                          (index) => (index ==
                                  (metronome.currentCycle - 1) %
                                      metronome.beatsPerMeasure)
                              ? const SmallCircle(isWorking: true)
                              : const SmallCircle(isWorking: false),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ));
  }

  Widget _clicksPerBeatSetter() {
    return Consumer<MetronomeController>(
      builder: (context, metronome, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                metronome.updateClicksPerBeat(metronome.clicksPerBeat - 1);
              },
              icon: const Icon(Icons.remove),
              iconSize: 28,
            ),
            Text(
              '${metronome.clicksPerBeat}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'BellotaText',
              ),
            ),
            IconButton(
              onPressed: () {
                metronome.updateClicksPerBeat(metronome.clicksPerBeat + 1);
              },
              icon: const Icon(Icons.add),
              iconSize: 25,
            ),
          ],
        );
      },
    );
  }

  Widget _beatsPerMeasureSetter() {
    return Consumer<MetronomeController>(
      builder: (context, metronome, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                metronome.updateBeatsPerMeasure(metronome.beatsPerMeasure - 1);
              },
              icon: const Icon(Icons.remove),
              iconSize: 28,
            ),
            Text(
              '${metronome.beatsPerMeasure}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'BellotaText',
              ),
            ),
            IconButton(
              onPressed: () {
                metronome.updateBeatsPerMeasure(metronome.beatsPerMeasure + 1);
              },
              icon: const Icon(Icons.add),
              iconSize: 25,
            ),
          ],
        );
      },
    );
  }
}
