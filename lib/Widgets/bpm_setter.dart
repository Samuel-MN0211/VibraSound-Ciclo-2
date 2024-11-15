import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/genre_selected_model.dart';
import 'package:metronomo_definitivo/Models/is_playing_model.dart';
import 'package:provider/provider.dart';
import '../Models/bpm_model.dart';

class BpmSetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bpmModel = Provider.of<BpmModel>(context);
    final GenreSelectedModel genreSelectedModel =
        Provider.of<GenreSelectedModel>(context);
    final IsPlayingModel isPlayingModel = Provider.of<IsPlayingModel>(context);

    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;

    final double iconSize = screenWidth * 0.1;
    final double fontSize = screenWidth * 0.15;
    final double buttonWidth = screenWidth * 0.15;
    final double buttonHeight = screenHeight * 0.06;
    final double buttonFontSize = screenWidth * 0.04;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isPlayingModel.isPlaying
                ? SizedBox.shrink()
                : Positioned(
                    top: screenHeight * 0.05,
                    right: screenWidth * 0.12,
                    child: GestureDetector(
                      onTap: () {
                        bpmModel.updateBpm(-10, true);
                        genreSelectedModel.genreSelected = '';
                      },
                      child: Container(
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
                            '-10',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonFontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            isPlayingModel.isPlaying
                ? SizedBox.shrink()
                : Positioned(
                    top: screenHeight * 0.05,
                    right: screenWidth * 0.12,
                    child: GestureDetector(
                      onTap: () {
                        bpmModel.updateBpm(10, true);
                        genreSelectedModel.genreSelected = '';
                      },
                      child: Container(
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
                            '+10',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonFontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                bpmModel.updateBpm(-1, true);
                genreSelectedModel.genreSelected = '';
              },
              icon: Icon(Icons.remove),
              iconSize: iconSize,
            ),
            Text(
              '${bpmModel.bpm}',
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'BellotaText',
              ),
            ),
            IconButton(
              onPressed: () {
                bpmModel.updateBpm(1, true);
                genreSelectedModel.genreSelected = '';
              },
              icon: Icon(Icons.add),
              iconSize: iconSize,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isPlayingModel.isPlaying
                ? SizedBox.shrink()
                : Positioned(
                    bottom: screenHeight * 0.05,
                    left: screenWidth * 0.12,
                    child: GestureDetector(
                      onTap: () {
                        bpmModel.updateBpm(-5, true);
                        genreSelectedModel.genreSelected = '';
                      },
                      child: Container(
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
                            '-5',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonFontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            isPlayingModel.isPlaying
                ? SizedBox.shrink()
                : Positioned(
                    bottom: screenHeight * 0.05,
                    right: screenWidth * 0.12,
                    child: GestureDetector(
                      onTap: () {
                        bpmModel.updateBpm(5, true);
                        genreSelectedModel.genreSelected = '';
                      },
                      child: Container(
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
                            '+5',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonFontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        )
        //

        //   Positioned(
        //     bottom: screenHeight * 0.06,
        //     child: Text(
        //       'BPM',
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: screenWidth * 0.05,
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
