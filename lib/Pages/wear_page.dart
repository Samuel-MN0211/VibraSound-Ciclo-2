import 'package:flutter/material.dart';
import 'package:wear/wear.dart';
import 'package:metronomo_definitivo/Widgets/active_component.dart';

class WearPage extends StatelessWidget {
  const WearPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (BuildContext context, WearShape shape, Widget? child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return mode == WearMode.active
                ? viewWatchActive()
                : viewWatchAmbient();
          },
        );
      },
    );
  }

  viewWatchActive() {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: ActiveComponent(),
    );
  }

  viewWatchAmbient() {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('ambiente'),
      ),
    );
  }
}
