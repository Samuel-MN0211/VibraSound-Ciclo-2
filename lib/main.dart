import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';
import 'home_page.dart';
import 'multiple_metronome_page.dart';

void main() {
  TorchController().initialize();
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
