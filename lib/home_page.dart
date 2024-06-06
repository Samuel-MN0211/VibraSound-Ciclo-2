import 'package:flutter/material.dart';
import 'metronome_instance.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metronome App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MetronomeInstance(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/multiple_metronomes');
              },
              child: const Text('Go to Multiple Metronomes'),
            )
          ],
        ),
      ),
    );
  }
}
