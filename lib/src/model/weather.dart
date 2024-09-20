class Weather {
  final int id;
  final String cityName;
  final double latitude, longitude;
  final String main, description, icon;
  final double temp, feelsLike, tempMin, tempMax, pressure;
  final int humidity;
  final double speed;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime date;

  const Weather({
    required this.id,
    required this.cityName,
    required this.longitude,
    required this.latitude,
    required this.main,
    required this.description,
    required this.icon,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.speed,
    required this.sunrise,
    required this.sunset,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': cityName,
      'coord': {
        'lon': longitude,
        'lat': latitude,
      },
      'weather': [
        {
          'main': main,
          'description': description,
          'icon': icon,
        }
      ],
      "sys": {
        "sunrise": sunrise.millisecondsSinceEpoch ~/ 1000,
        "sunset": sunset.millisecondsSinceEpoch ~/ 1000,
      },
      'main': {
        'temp': temp,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'pressure': pressure,
        'humidity': humidity,
      },
      'wind': {'speed': speed},
      'dt': date.millisecondsSinceEpoch ~/ 1000
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      id: map['id'] as int,
      cityName: map['name'] as String,
      longitude: map['coord']['lon'] as double,
      latitude: map['coord']['lat'] as double,
      main: map['weather'][0]['main'] as String,
      description: map['weather'][0]['description'] as String,
      icon: map['weather'][0]['icon'] as String,
      temp: (map['main']['temp'] as num).toDouble(),
      feelsLike: (map['main']['feels_like'] as num).toDouble(),
      tempMin: (map['main']['temp_min'] as num).toDouble(),
      tempMax: (map['main']['temp_max'] as num).toDouble(),
      pressure: (map['main']['pressure'] as num).toDouble(),
      humidity: (map['main']['humidity'] as num).toInt(),
      speed: (map['wind']['speed'] as num).toDouble(),
      sunrise: DateTime.fromMillisecondsSinceEpoch(
          (map['sys']['sunrise'] as int) * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(
          (map['sys']['sunset'] as int) * 1000),
      date: DateTime.fromMillisecondsSinceEpoch((map['dt'] as int) * 1000),
    );
  }
}
