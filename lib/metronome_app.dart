import 'package:flutter/material.dart';
import 'home_page.dart';
import 'multiple_metronome_page.dart';

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
