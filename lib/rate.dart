import 'package:flutter/material.dart';

class Rate with ChangeNotifier {
  double _rateEuroKrona = 150;

  double get rateEuroKrona => _rateEuroKrona;
  double get rateKronaEuro => _rateEuroKrona > 0 ? 1 / _rateEuroKrona : 0;

  void changeRate(double newValue) {
    _rateEuroKrona = newValue;
    notifyListeners();
  }
}
