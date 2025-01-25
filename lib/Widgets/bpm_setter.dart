import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/genre_selected_model.dart';
import 'package:metronomo_definitivo/Models/is_playing_model.dart';
import 'package:metronomo_definitivo/controllers/metronome_controller.dart';
import 'package:provider/provider.dart';

class BpmSetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MetronomeController metronome =
        Provider.of<MetronomeController>(context);
    final GenreSelectedModel genreSelectedModel =
        Provider.of<GenreSelectedModel>(context);
    final IsPlayingModel isPlayingModel = Provider.of<IsPlayingModel>(context);

    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final double iconSize = screenWidth * 0.1;
    final double fontSize = screenWidth * 0.15;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isPlayingModel.isPlaying
                ? const SizedBox.shrink()
                : Positioned(
                    top: screenHeight * 0.05,
                    right: screenWidth * 0.12,
                    child: GestureDetector(
                      onTap: () {
                        metronome.updateBpm(metronome.bpm - 10);
                        genreSelectedModel.genreSelected = '';
                      },
                      child: _setter(context, '-10'),
                    ),
                  ),
            isPlayingModel.isPlaying
                ? const SizedBox.shrink()
                : Positioned(
                    top: screenHeight * 0.05,
                    right: screenWidth * 0.12,
                    child: GestureDetector(
                      onTap: () {
                        metronome.updateBpm(metronome.bpm + 10);
                        genreSelectedModel.genreSelected = '';
                      },
                      child: _setter(context, '+10'),
                    ),
                  ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                metronome.updateBpm(metronome.bpm - 1);
                genreSelectedModel.genreSelected = '';
              },
              icon: const Icon(Icons.remove),
              iconSize: iconSize,
            ),
            Text(
              '${metronome.bpm}',
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'BellotaText',
              ),
            ),
            IconButton(
              onPressed: () {
                metronome.updateBpm(metronome.bpm + 1);
                genreSelectedModel.genreSelected = '';
              },
              icon: const Icon(Icons.add),
              iconSize: iconSize,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isPlayingModel.isPlaying
                ? const SizedBox.shrink()
                : Positioned(
                    bottom: screenHeight * 0.05,
                    left: screenWidth * 0.12,
                    child: GestureDetector(
                      onTap: () {
                        metronome.updateBpm(metronome.bpm - 5);
                        genreSelectedModel.genreSelected = '';
                      },
                      child: _setter(context, '-5'),
                    ),
                  ),
            isPlayingModel.isPlaying
                ? const SizedBox.shrink()
                : Positioned(
                    bottom: screenHeight * 0.05,
                    right: screenWidth * 0.12,
                    child: GestureDetector(
                      onTap: () {
                        metronome.updateBpm(metronome.bpm + 5);
                        genreSelectedModel.genreSelected = '';
                      },
                      child: _setter(context, '+5'),
                    ),
                  ),
          ],
        )
      ],
    );
  }

  Widget _setter(BuildContext context, String value) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final double buttonWidth = screenWidth * 0.15;
    final double buttonHeight = screenHeight * 0.06;
    final double buttonFontSize = screenWidth * 0.04;
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: buttonFontSize,
          ),
        ),
      ),
    );
  }
}
