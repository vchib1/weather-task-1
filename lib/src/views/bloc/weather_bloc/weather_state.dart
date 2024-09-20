part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitialState extends WeatherState {
  const WeatherInitialState();
}

class WeatherLoadingState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  final Weather weather;

  const WeatherLoadedState(this.weather);

  @override
  List<Object?> get props => [weather];
}

class WeatherLocNotEnabledState extends WeatherState {
  const WeatherLocNotEnabledState();
}

class WeatherNoInternetState extends WeatherState {
  final String error;

  const WeatherNoInternetState(this.error);

  @override
  List<Object?> get props => [error];
}

class WeatherErrorState extends WeatherState {
  final String error;

  const WeatherErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
