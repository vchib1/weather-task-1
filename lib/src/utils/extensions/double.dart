extension DoubleExtension on double {
  String toTempString([bool useCelsius = false]) {
    if (useCelsius) {
      return (this - 273.15).ceilToDouble().toStringAsFixed(0);
    }
    return ((this - 273.15) * (9 / 5) + 32).toStringAsFixed(0);
  }

  String get toWindSpeedKpm => (this * 3.6).toStringAsFixed(2);
}
