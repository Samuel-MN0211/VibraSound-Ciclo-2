import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/beats_model.dart';
import 'package:metronomo_definitivo/Models/bpm_model.dart';
import 'package:metronomo_definitivo/Models/compasso_model.dart';
import 'package:metronomo_definitivo/Models/genre_selected_model.dart';
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
    final bpmModel = Provider.of<BpmModel>(context, listen: false);
    final beatsModel = Provider.of<BeatsModel>(context, listen: false);
    final compassoModel = Provider.of<CompassoModel>(context, listen: false);
    final GenreSelectedModel genreSelectedModel =
        Provider.of<GenreSelectedModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Card(
            color: Color(0xFF095169),
            child: ListTile(
              title: Text(
                genre['name'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Text(
                  'BPM: ${genre['bpm']}, Compasso: ${genre['compasso']}, Batidas: ${genre['batidas']}',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                bpmModel.updateBpm(genre['bpm'], false);
                beatsModel.updateBeats(genre['batidas'], false);
                compassoModel.updateCompasso(genre['compasso'], false);
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
