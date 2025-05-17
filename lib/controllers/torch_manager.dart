import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';

class TorchManager extends ChangeNotifier {
  bool _isTorchOn = false;
  bool get isTorchOn => _isTorchOn;

  final TorchController _torchController = TorchController();

  void toggleTorch() {
    _isTorchOn = !_isTorchOn;
    notifyListeners();
  }

  void torchOn(int vibrationDuration) {
    if (isTorchOn) {
      _torchController.toggle(intensity: 1);
      Future.delayed(Duration(milliseconds: vibrationDuration), () {
        _torchController.toggle();
      });
    }
  }
}
