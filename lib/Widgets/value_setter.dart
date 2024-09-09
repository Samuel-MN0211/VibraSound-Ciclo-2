import 'package:flutter/material.dart';
import 'package:metronomo_definitivo/Models/genre_selected_model.dart';
import 'package:provider/provider.dart';

class ValueSetter<T extends ChangeNotifier> extends StatelessWidget {
  final int Function(T) getValue;
  final void Function(T, int, bool) updateValue;

  ValueSetter({
    required this.getValue,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<T>(context);
    final GenreSelectedModel genreSelectedModel =
        Provider.of<GenreSelectedModel>(context);
    int currentValue = getValue(model);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            updateValue(model, -1, true);
            genreSelectedModel.genreSelected = ''; // Diminui 1 unidade
          },
          icon: const Icon(Icons.remove),
          iconSize: 28,
        ),
        Container(
          child: Text(
            '$currentValue',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'BellotaText',
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            updateValue(model, 1, true);
            genreSelectedModel.genreSelected = ''; // Aumenta 1 unidade
          },
          icon: const Icon(Icons.add),
          iconSize: 25,
        ),
      ],
    );
  }
}
