import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/beats_model.dart';
import 'package:metronomo_definitivo/Models/bpm_model.dart';
import 'package:metronomo_definitivo/Models/compasso_model.dart';
import 'package:provider/provider.dart';
import 'metronome_instance.dart';
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
    return Scaffold(
      body: ListView.builder(
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return ListTile(
            title: Text(genre['name']),
            subtitle: Text(
                'BPM: ${genre['bpm']}, Compasso: ${genre['compasso']}, Batidas: ${genre['batidas']}'),
            onTap: () {
              bpmModel.updateBpm(genre['bpm'], false);
              beatsModel.updateBeats(genre['batidas'], false);
              compassoModel.updateCompasso(genre['compasso'], false);
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
          );
        },
      ),
    );
  }
}
