import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Pages/wear_page.dart';
import 'package:metronomo_definitivo/controllers/metronome_controller.dart';
import 'package:provider/provider.dart';
import '../Widgets/metronome_instance.dart';
import '../Widgets/side_menu.dart' as side_menu;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          debugPrint('Host device screen width: ${constraints.maxWidth}');
          if (constraints.maxWidth < 300) {
            return const WearPage();
          } else {
            return phonePage(context);
          }
        },
      );
}

Widget phonePage(BuildContext context) {
  final metronome = Provider.of<MetronomeController>(context);

  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: metronome.color,
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
