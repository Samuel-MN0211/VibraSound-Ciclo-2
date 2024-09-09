import 'package:flutter/material.dart';

class GenreSelectedModel with ChangeNotifier {
  String _genreSelected = '';

  String get genreSelected => _genreSelected;

  set genreSelected(String value) {
    if (_genreSelected != value) {
      _genreSelected = value;
      notifyListeners();
    }
  }
}
