import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/genre_selected_model.dart';
import 'package:metronomo_definitivo/Widgets/ticks_compasso.dart';
import 'package:metronomo_definitivo/controllers/metronome_controller.dart';
import 'package:provider/provider.dart';
import 'package:torch_controller/torch_controller.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import '../Models/bpm_scheduler_model.dart';
import 'bpm_setter.dart';
import '../Models/color_model.dart';
import 'dart:collection'; // Import necessário para a Queue

class MetronomeInstance extends StatefulWidget {
  final Function? onStateChanged;

  const MetronomeInstance({Key? key, this.onStateChanged}) : super(key: key);

  @override
  MetronomeInstanceState createState() => MetronomeInstanceState();
}

class MetronomeInstanceState extends State<MetronomeInstance> {
  late MetronomeController metronome;
  bool _isTorchOn = false;
  bool _isVibrating = true;
  Timer? _clickTimer;
  //int _currentTick = 0;
  int _currentCycle = 0;
  int _currentBeat = 0;
  int timerRunning = 0;
  Timer? _timer;
  late Queue<AudioPlayer> _clickPlayers;
  late Queue<AudioPlayer> _specialClickPlayers;
  late Duration _clickDuration;
  late Duration _specialClickDuration;

  // Controllers
  final TorchController _torchController = TorchController();

  @override
  void initState() {
    super.initState();
    metronome = Provider.of<MetronomeController>(context, listen: false);
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
    _currentBeat++;
    final colorModel = Provider.of<ColorModel>(context, listen: false);

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

    // if (bpmModel.hasChanged) {
    //   _metronome.stop();
    //   _metronome = Metronome(bpm: bpmModel.bpm, clicksPerBeat: clicksPerBeat);
    //   _metronome.onTick(_onTick);
    //   _metronome.start();

    //   interval = (60000 / (bpmModel.bpm * clicksPerBeat)).round();
    //   vibrationDuration = interval ~/ 2;
    //   bpmModel.resetChangeFlag();
    // }

    if (_currentBeat % metronome.clicksPerBeat == 1 ||
        metronome.clicksPerBeat == 1) {
      _currentCycle++;
      _currentBeat = 1;
      vibrationDuration = (interval * 0.8).round();
      colorModel.changeToBlack();
      _torchOn(_isTorchOn, vibrationDuration);
      _playSound(_specialClickPlayers, _specialClickDuration, 'tick.wav');
    } else {
      _torchOn(_isTorchOn, vibrationDuration);
      _playSound(_clickPlayers, _clickDuration, 'clique.wav');
      colorModel.changeToRandomColor();
    }

    _vibrateOn(_isVibrating, vibrationDuration);

    if (_currentCycle > metronome.beatsPerMeasure) {
      _currentCycle = 1;
    }
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
        _currentBeat = 0;
        _currentCycle = 0;
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
    metronome.dispose();
    _clickTimer?.cancel();
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
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final colorModel = Provider.of<ColorModel>(context);
    return Container(
      height: screenWidth * 0.6,
      width: screenWidth * 0.6,
      decoration: BoxDecoration(
        color: colorModel.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$_currentBeat',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.12,
            fontWeight: FontWeight.bold,
            fontFamily: 'BellotaText',
          ),
        ),
      ),
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
        color: _isVibrating ? Colors.black : Colors.grey,
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
        color: _isTorchOn ? Colors.black : Colors.grey,
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
                                  (_currentCycle - 1) %
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
