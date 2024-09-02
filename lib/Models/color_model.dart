import 'package:flutter/material.dart';

class ColorModel extends ChangeNotifier {
  Color _backgroundColor = Color(0xFF095169);

  Color get backgroundColor => _backgroundColor;

  set backgroundColor(Color value) {
    _backgroundColor = value;
    notifyListeners(); // Notificar sobre a mudança de cor
  }

  void changeToBlack() {
    backgroundColor = Colors.black;
  }

  void changeToRandomColor() {
    if (backgroundColor == Colors.black) {
      backgroundColor = Colors.green;
    } else if (backgroundColor == Colors.green) {
      backgroundColor = Colors.blue;
    } else {
      backgroundColor = Colors.green;
    }
  }
}
