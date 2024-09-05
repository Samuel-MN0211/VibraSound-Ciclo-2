import 'package:flutter/material.dart';
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
    int currentValue = getValue(model);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            updateValue(model, -1, true); // Diminui 1 unidade
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
            updateValue(model, 1, true); // Aumenta 1 unidade
          },
          icon: const Icon(Icons.add),
          iconSize: 25,
        ),
      ],
    );
  }
}
