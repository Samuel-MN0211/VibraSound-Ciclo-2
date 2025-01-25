import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/genre_selected_model.dart';
import 'package:metronomo_definitivo/controllers/metronome_controller.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';

class Samples extends StatefulWidget {
  const Samples({Key? key}) : super(key: key);

  @override
  _SamplesState createState() => _SamplesState();
}

class _SamplesState extends State<Samples> {
  List<dynamic> genres = [];

  // Carrega os dados dos gêneros musicais do arquivo JSON
  @override
  void initState() {
    super.initState();
    loadGenres();
  }

  Future<void> loadGenres() async {
    final String response =
        await rootBundle.loadString('assets/music_genres.json');
    final data = await json.decode(response);
    setState(() {
      genres = data['genres'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final GenreSelectedModel genreSelectedModel =
        Provider.of<GenreSelectedModel>(context, listen: false);
    final metronome = Provider.of<MetronomeController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Card(
            color: const Color(0xFF095169),
            child: ListTile(
              title: Text(
                genre['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Text(
                  'BPM: ${genre['bpm']}, Compasso: ${genre['compasso']}, Batidas: ${genre['batidas']}',
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                metronome.updateBpm(genre['bpm']);
                metronome.updateClicksPerBeat(genre['batidas']);
                metronome.updateBeatsPerMeasure(genre['compasso']);
                genreSelectedModel.genreSelected = genre['name'];
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "Genero selecionado: ${genre['name']}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            ),
          );
        },
      ),
    );
  }
}
