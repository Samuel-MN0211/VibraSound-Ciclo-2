import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/genre_selected_model.dart';
import 'package:metronomo_definitivo/Models/is_playing_model.dart';
import 'package:provider/provider.dart';
import 'package:torch_controller/torch_controller.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import '../Models/beats_model.dart';
import '../Models/bpm_model.dart';
import '../Models/bpm_scheduler_model.dart';
import 'bpm_setter.dart';
import '../Models/color_model.dart';
import '../Models/compasso_model.dart';
import '../Models/metronome_model.dart';
import 'value_setter.dart' as custom;
import 'dart:collection'; // Import necessário para a Queue

class MetronomeInstance extends StatefulWidget {
  final Function? onStateChanged;

  const MetronomeInstance({Key? key, this.onStateChanged}) : super(key: key);

  @override
  MetronomeInstanceState createState() => MetronomeInstanceState();
}

class MetronomeInstanceState extends State<MetronomeInstance> {
  late Metronome _metronome;
  bool _isTorchOn = false;
  bool _isVibrating = true;
  Timer? _clickTimer;
  int _currentTick = 0;
  int _currentCycle = 0;
  int _currentBeat = 0;
  late Queue<AudioPlayer> _clickPlayers;
  late Queue<AudioPlayer> _specialClickPlayers;
  late Duration _clickDuration;
  late Duration _specialClickDuration;

  // Controllers
  final TorchController _torchController = TorchController();

  @override
  void initState() {
    super.initState();
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

    final beatsPerMeasure =
        Provider.of<CompassoModel>(context, listen: false).compasso;
    final clicksPerBeat = Provider.of<BeatsModel>(context, listen: false).beats;
    final colorModel = Provider.of<ColorModel>(context, listen: false);
    final bpmModel = Provider.of<BpmModel>(context, listen: false);
    final bpmScheduler = Provider.of<BpmSchedulerModel>(context, listen: false);

    int interval = (60000 / (bpmModel.bpm * clicksPerBeat)).round();
    int vibrationDuration = interval ~/ 2;

    if (bpmScheduler.isActivated) {
      final now = DateTime.now();
      if (now.difference(bpmScheduler.lastChange).inSeconds >=
          bpmScheduler.secondsToMakeChange) {
        bpmModel.updateBpm(bpmScheduler.valueToChange, true);
        bpmScheduler.lastChange = now;

        // reinicia o metronome com os novos valores
        _metronome.stop();
        _metronome = Metronome(bpm: bpmModel.bpm, clicksPerBeat: clicksPerBeat);
        _metronome.onTick(_onTick);
        _metronome.start();

        interval = (60000 / (bpmModel.bpm * clicksPerBeat)).round();
        vibrationDuration = interval ~/ 2;
      }
    }

    if (_currentTick % clicksPerBeat == 1) {
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

    if (_currentCycle > beatsPerMeasure) {
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

  void _togglePlayPause() {
    final isPlayingModel = Provider.of<IsPlayingModel>(context, listen: false);
    final bpmScheduler = Provider.of<BpmSchedulerModel>(context, listen: false);
    setState(() {
      if (isPlayingModel.isPlaying) {
        _metronome.stop();
        _currentTick = 0;
        _currentCycle = 0;
        bpmScheduler.desactiveScheduler();
      } else {
        final bpm = Provider.of<BpmModel>(context, listen: false).bpm;
        final clicksPerBeat =
            Provider.of<BeatsModel>(context, listen: false).beats;

        if (bpmScheduler.isActivated) {
          bpmScheduler.lastChange = DateTime.now();
        }
        _metronome = Metronome(bpm: bpm, clicksPerBeat: clicksPerBeat);
        _metronome.onTick(_onTick);
        _metronome.start();
      }
      isPlayingModel.isPlaying = !isPlayingModel.isPlaying;
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
    final isPlayingModel = Provider.of<IsPlayingModel>(context);
    final isPlaying = isPlayingModel.isPlaying;
    final colorModel = Provider.of<ColorModel>(context);
    final GenreSelectedModel genreSelectedModel =
        Provider.of<GenreSelectedModel>(context);

    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            BpmSetter(),
            Container(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(right: screenWidth * 0.08),
                  child: Text(
                    genreSelectedModel.genreSelected,
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            isPlaying
                ? const SizedBox.shrink()
                : FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 50)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Compasso',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.05),
                                ),
                                custom.ValueSetter<CompassoModel>(
                                  getValue: (model) => model.compasso,
                                  updateValue: (model, value, isIncrement) =>
                                      model.updateCompasso(value, isIncrement),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Batidas',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.05)),
                                custom.ValueSetter<BeatsModel>(
                                  getValue: (model) => model.beats,
                                  updateValue: (model, value, isIncrement) =>
                                      model.updateBeats(value, isIncrement),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isPlaying
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: _toggleIsVibrateOn,
                        icon: Icon(
                          Icons.vibration,
                          color: _isVibrating ? Colors.black : Colors.grey,
                        ),
                        iconSize: screenWidth * 0.1,
                      ),
                IconButton(
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
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
                isPlaying
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: _toggleIsTorchOn,
                        icon: Icon(
                          Icons.flashlight_on,
                          color: _isTorchOn ? Colors.black : Colors.grey,
                        ),
                        iconSize: screenWidth * 0.1,
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}
