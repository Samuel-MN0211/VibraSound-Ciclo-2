import 'package:flutter/material.dart';

class ColorModel extends ChangeNotifier {
  Color _backgroundColor = Colors.black;

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
}
