enum TempUnit {
  celsius,
  fahrenheit;

  static TempUnit parse(String value) {
    switch (value) {
      case 'celsius':
        return TempUnit.celsius;
      case 'fahrenheit':
        return TempUnit.fahrenheit;
      default:
        return TempUnit.celsius;
    }
  }


}
