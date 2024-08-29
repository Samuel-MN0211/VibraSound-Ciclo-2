import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/beats_model.dart';
import 'package:metronomo_definitivo/bpm_model.dart';
import 'package:provider/provider.dart';
import 'package:torch_controller/torch_controller.dart';
import 'color_model.dart';
import 'compasso_model.dart';
import 'home_page.dart';
import 'isPlaying_model.dart';
import 'multiple_metronome_page.dart';
import 'samples.dart';

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
        ChangeNotifierProvider(create: (context) => BpmModel()),
        ChangeNotifierProvider(create: (context) => CompassoModel()),
        ChangeNotifierProvider(create: (context) => BeatsModel()),
        ChangeNotifierProvider(create: (context) => IsPlayingModel()),
        ChangeNotifierProvider(create: (context) => ColorModel())
      ], // Use more descriptive variable name
      child: Consumer<BpmModel>(
        builder: (context, samplesController, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
            routes: {
              '/multiple_metronomes': (context) =>
                  const MultipleMetronomePage(),
            },
          );
        },
      ),
    );
  }
}
