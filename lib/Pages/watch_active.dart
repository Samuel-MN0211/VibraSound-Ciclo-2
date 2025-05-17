import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/controllers/metronome_controller.dart';
import 'package:metronomo_definitivo/controllers/sound_controller.dart';
import 'package:metronomo_definitivo/controllers/torch_manager.dart';
import 'package:metronomo_definitivo/controllers/vibration_controller.dart';
import 'package:provider/provider.dart';

class WatchActive extends StatefulWidget {
  const WatchActive({super.key});

  @override
  State<WatchActive> createState() => _WatchActiveState();
}

class _WatchActiveState extends State<WatchActive> {
  // late MetronomeController metronome;
  // late SoundController soundController;
  // late VibrationController vibrationController;
  // late TorchManager torchManager;

  // @override
  // void initState() {
  //   super.initState();
  //   metronome = Provider.of<MetronomeController>(context, listen: false);
  //   soundController = Provider.of<SoundController>(context, listen: false);
  //   vibrationController =
  //       Provider.of<VibrationController>(context, listen: false);
  //   torchManager = Provider.of<TorchManager>(context, listen: false);
  //   soundController.preloadSounds();
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text('120', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
