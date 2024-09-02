import 'package:flutter/material.dart';

class ColorModel extends ChangeNotifier {
  Color _backgroundColor = Color(0xFF095169);

  Color get backgroundColor => _backgroundColor;

  set backgroundColor(Color value) {
    print('-------------------------------------------------------------');
    print('-------------------------------------------------------------');
    print('ColorModel.backgroundColor: $value');
    print('-------------------------------------------------------------');
    print('-------------------------------------------------------------');
    _backgroundColor = value;
    notifyListeners(); // Notificar sobre a mudança de cor
  }

  void changeToBlack() {
    backgroundColor = Colors.black;
  }

  void changeToRandomColor() {
    if (backgroundColor == Colors.black) {
      print('deveria atualizar para verde');
      backgroundColor = Colors.green;
    } else if (backgroundColor == Colors.green) {
      print('deveria atualizar para azul');
      backgroundColor = Colors.blue;
    } else {
      backgroundColor = Colors.green;
      print('deveria atualizar para verde');
    }
  }
}
