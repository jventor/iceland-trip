class Tools {
  static String changeCurrency(double amount, double rate, int precition) {
    return (amount * rate).toStringAsFixed(precition);
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
