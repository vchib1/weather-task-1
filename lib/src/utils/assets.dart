class Assets {
  static String getWeatherIcon({String code = "01d"}) =>
      "assets/icons/$code@4x.png";

  /// SVGs
  static String feelsLikeSvg = "assets/svg/feels_like.svg";
  static String humiditySvg = "assets/svg/humidity.svg";
  static String windSvg = "assets/svg/wind.svg";
  static String noInternetSvg = "assets/svg/no_internet.svg";
  static String errorSvg = "assets/svg/error_illustration.svg";
  static String locationIconSvg = "assets/svg/location_icon.svg";
  static String locationIllustrationSvg =
      "assets/svg/location_illustration.svg";

  /// WEATHER TYPE BACKGROUND
  static String getWeatherBackground({String? code = "01d"}) =>
      "assets/background/$code.jpg";

  /// Lottie Animations Json
  static String clearDayJson = "assets/animations/01d.json";
  static String clearNightJson = "assets/animations/01n.json";
  static String cloudyDayJson = "assets/animations/02d.json";
  static String cloudyNightJson = "assets/animations/02n.json";
  static String cloudsJson = "assets/animations/03d.json";
  static String rainDayJson = "assets/animations/09d.json";
  static String rainNightJson = "assets/animations/09n.json";
  static String thunderJson = "assets/animations/11d.json";
  static String snowJson = "assets/animations/13d.json";
  static String mistJson = "assets/animations/50d.json";
  static String loadingAnimationJson =
      "assets/animations/loading_animation.json";

  static String getAnimation({String? code = "01d"}) {
    switch (code!) {
      case "01d":
        return clearDayJson;
      case "01n":
        return clearNightJson;
      case "02d":
        return cloudyDayJson;
      case "02n":
        return cloudyNightJson;
      case "03d":
      case "03n":
      case "04d":
      case "04n":
        return cloudsJson;
      case "09d":
      case "10d":
        return rainDayJson;
      case "09n":
      case "10n":
        return rainNightJson;
      case "11d":
      case "11n":
        return thunderJson;
      case "13d":
      case "13n":
        return snowJson;
      case "50d":
      case "50n":
        return mistJson;
      default:
        return clearDayJson;
    }
  }
}
