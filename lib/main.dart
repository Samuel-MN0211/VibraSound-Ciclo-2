import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/bpm_scheduler_model.dart';
import 'package:metronomo_definitivo/controllers/metronome_controller.dart';
import 'package:provider/provider.dart';
import 'package:torch_controller/torch_controller.dart';
import 'Models/genre_selected_model.dart';
import 'Pages/home_page.dart';
import 'Pages/multiple_metronome_page.dart';

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
        ChangeNotifierProvider(create: (context) => MetronomeController()),
        ChangeNotifierProvider(create: (context) => BpmSchedulerModel()),
        ChangeNotifierProvider(create: (context) => GenreSelectedModel()),
      ],
      child: Consumer<MetronomeController>(
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
