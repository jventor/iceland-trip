import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iceland_trip/inputs_formatters/euro_regex_input_formatter.dart';

import 'inputs_formatters/krona_regex_input_formatter.dart';

enum Currencies { eur, usd }

enum Mode { toKrona, toCurrency }

class Currency {
  final String name;
  final String shortName;
  final String flag;
  double rate;
  double invRate;
  TextInputFormatter formatter;
  List<double> amounts;

  Currency(
      {required this.name,
      required this.shortName,
      required this.rate,
      required this.flag,
      required this.formatter,
      required this.amounts})
      : invRate = rate > 0 ? 1 / rate : 0;
}

class Rate with ChangeNotifier {
  Currency iskCurrency = Currency(
      flag: 'assets/images/iceland-flag.png',
      formatter: KronaRegExInputFormatter(),
      name: 'Krona',
      shortName: 'ISK',
      rate: 0,
      amounts: [
        5,
        10,
        25,
        50,
        75,
        100,
        250,
        500,
        750,
        1000,
        2500,
        5000,
        7500,
        10000,
        25000,
        50000,
        75000,
        100000,
        250000,
        500000
      ]);

  final List<Currency> _currencies = [
    Currency(
        name: 'Euro',
        shortName: 'EUR',
        rate: 150,
        flag: 'assets/images/eur-flag.png',
        formatter: EuroRegExInputFormatter(),
        amounts: [
          0.5,
          1,
          3,
          5,
          8,
          10,
          15,
          20,
          30,
          50,
          75,
          100,
          150,
          300,
          500,
          750,
          1000,
          3000,
          5000,
          10000
        ])
  ];

  int _currentCurrencyIndex;

  Mode _currentMode = Mode.toCurrency;

  Rate({required Currencies initialCurrency})
      : _currentCurrencyIndex = initialCurrency.index;

  Currency get currentCurrency => _currencies[_currentCurrencyIndex];
  Mode get currentMode => _currentMode;

  void changeRate(double newValue) {
    _currencies[_currentCurrencyIndex].rate = newValue;
    _currencies[_currentCurrencyIndex].invRate =
        newValue > 0 ? 1 / newValue : 0;
    notifyListeners();
  }

  void changeCurrency(Currencies newValue) {
    _currentCurrencyIndex = newValue.index;
    notifyListeners();
  }

  void changeMode() {
    _currentMode =
        _currentMode == Mode.toCurrency ? Mode.toKrona : Mode.toCurrency;
    notifyListeners();
  }
}
