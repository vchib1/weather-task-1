part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class GetWeatherByCityName extends WeatherEvent {
  final String cityName;
  final int id;
  final bool refresh;

  const GetWeatherByCityName(this.cityName, this.id, [this.refresh = false]);

  @override
  List<Object> get props => [cityName, id, refresh];
}

class NoInternetConnection extends WeatherEvent {}

class LocationNotEnabled extends WeatherEvent {}

class WeatherLoadingEvent extends WeatherEvent {}

class WeatherErrorEvent extends WeatherEvent {
  final String error;

  const WeatherErrorEvent(this.error);

  @override
  List<Object> get props => [error];
}

class GetWeatherByCoordinates extends WeatherEvent {
  final double longitude;
  final double latitude;
  final bool refresh;
  final int id;

  const GetWeatherByCoordinates(this.longitude, this.latitude, this.id,
      [this.refresh = false]);

  @override
  List<Object> get props => [longitude, latitude, id, refresh];
}
