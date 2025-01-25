import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/color_model.dart';
import 'package:metronomo_definitivo/controllers/metronome_controller.dart';
import 'package:provider/provider.dart';
// import '../Models/is_playing_model.dart';
import '../Widgets/metronome_instance.dart';
import '../Widgets/side_menu.dart' as side_menu;

void main() => runApp(const MetronomeApp());

class MetronomeApp extends StatelessWidget {
  const MetronomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ColorModel()),
        ChangeNotifierProvider(create: (context) => MetronomeController()),
      ],
      child: MaterialApp(
        title: 'VIBRASOM',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final isPlayingModel = Provider.of<IsPlayingModel>(context);
    final colorModel = Provider.of<ColorModel>(context);
    final metronome = Provider.of<MetronomeController>(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: colorModel.backgroundColor,
        ),
        AnimatedContainer(
          curve: Curves.easeInQuart,
          duration: const Duration(milliseconds: 350),
          width: metronome.isPlaying
              ? MediaQuery.of(context).size.width * 0.85
              : MediaQuery.of(context).size.width,
          height: metronome.isPlaying
              ? MediaQuery.of(context).size.height * 0.85
              : MediaQuery.of(context).size.height,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF095169),
              iconTheme: IconThemeData(
                color: metronome.isPlaying ? Colors.transparent : Colors.white,
              ),
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
            body: const MetronomeInstance(),
          ),
        ),
      ],
    );
  }
}
