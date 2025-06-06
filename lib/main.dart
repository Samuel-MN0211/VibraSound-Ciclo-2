import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/bpm_scheduler_model.dart';
import 'package:metronomo_definitivo/controllers/metronome_controller.dart';
import 'package:metronomo_definitivo/controllers/sound_controller.dart';
import 'package:metronomo_definitivo/controllers/torch_manager.dart';
import 'package:metronomo_definitivo/controllers/watch_metronome_controller.dart';
import 'package:provider/provider.dart';
import 'package:torch_controller/torch_controller.dart';
import 'Models/genre_selected_model.dart';
import 'Pages/home_page.dart';
import 'Pages/multiple_metronome_page.dart';
import 'controllers/vibration_controller.dart';

void main() {
  TorchController().initialize();
  runApp(const MetronomeApp());
}

class MetronomeApp extends StatelessWidget {
  const MetronomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SoundController()),
        ChangeNotifierProvider(create: (context) => VibrationController()),
        ChangeNotifierProvider(create: (context) => TorchManager()),
        ChangeNotifierProvider(create: (context) => BpmSchedulerModel()),
        ChangeNotifierProvider(create: (_) => WatchMetronomeController()),
        ChangeNotifierProvider(
          create: (context) => MetronomeController(
            soundController: context.read<SoundController>(),
            vibrationController: context.read<VibrationController>(),
            torchManager: context.read<TorchManager>(),
            bpmScheduler: context.read<BpmSchedulerModel>(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => GenreSelectedModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        routes: {
          '/multiple_metronomes': (context) => const MultipleMetronomePage(),
        },
      ),
    );
  }
}
