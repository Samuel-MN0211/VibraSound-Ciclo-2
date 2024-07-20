import 'package:flutter/material.dart';
import 'metronome_instance.dart';
import 'side_menu.dart' as side_menu;

void main() => runApp(const MetronomeApp());

class MetronomeApp extends StatelessWidget {
  const MetronomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIBRASOM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<MetronomeInstanceState> _metronomeKey =
      GlobalKey<MetronomeInstanceState>();
  bool _isPlaying = false;
  Color _backgroundColor = const Color(0xFF095169);

  @override
  void initState() {
    super.initState();
  }

  void _updateBackgroundColor() {
    setState(() {
      _backgroundColor = _metronomeKey.currentState?.backgroundColor ??
          const Color(0xFF095169);
    });
  }

  void _updateIsPlaying() {
    setState(() {
      _isPlaying = _metronomeKey.currentState?.isPlaying ?? false;
      _updateBackgroundColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: _backgroundColor,
      ),
      AnimatedContainer(
        curve: Curves.easeInQuart,
        duration: const Duration(milliseconds: 350),
        width: _isPlaying
            ? MediaQuery.of(context).size.width * 0.85
            : MediaQuery.of(context).size.width,
        height: _isPlaying
            ? MediaQuery.of(context).size.height * 0.85
            : MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF095169),
            iconTheme: _isPlaying
                ? IconThemeData(color: Colors.transparent)
                : IconThemeData(color: Colors.white),
            centerTitle: true,
            title: const Text(
              'Vibrasom',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontFamily: 'BellotaText',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          drawer: const side_menu.NavigationDrawer(),
          body: Center(
            child: MetronomeInstance(
              key: _metronomeKey,
              onStateChanged: () {
                _updateIsPlaying();
                _updateBackgroundColor();
              },
            ),
          ),
        ),
      ),
    ]);
  }
}
