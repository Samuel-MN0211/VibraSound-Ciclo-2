import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/genre_selected_model.dart';
import 'package:provider/provider.dart';
import '../Models/bpm_model.dart';

class BpmSetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bpmModel = Provider.of<BpmModel>(context);
    final GenreSelectedModel genreSelectedModel =
        Provider.of<GenreSelectedModel>(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 70, 20, 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  bpmModel.updateBpm(-1, true);
                  genreSelectedModel.genreSelected = '';
                },
                icon: Icon(Icons.remove),
                iconSize: 48,
              ),
              Container(
                child: Text(
                  '${bpmModel.bpm}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 58,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BellotaText',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  bpmModel.updateBpm(1, true);
                  genreSelectedModel.genreSelected = '';
                },
                icon: Icon(Icons.add),
                iconSize: 48,
              ),
            ],
          ),
        ),
        Positioned(
          top: 35,
          right: 45,
          child: GestureDetector(
            onTap: () {
              bpmModel.updateBpm(10, true);
              genreSelectedModel.genreSelected = '';
            },
            child: Container(
              width: 55,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '+10',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 35,
          left: 45,
          child: GestureDetector(
            onTap: () {
              bpmModel.updateBpm(-10, true);
              genreSelectedModel.genreSelected = '';
            },
            child: Container(
              width: 55,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '-10',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 35,
          right: 50,
          child: GestureDetector(
            onTap: () {
              bpmModel.updateBpm(5, true);
              genreSelectedModel.genreSelected = '';
            },
            child: Container(
              width: 55,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '+5',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 35,
          left: 45,
          child: GestureDetector(
            onTap: () {
              bpmModel.updateBpm(-5, true);
              genreSelectedModel.genreSelected = '';
            },
            child: Container(
              width: 55,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '-5',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 45,
          child: Text('BPM', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
