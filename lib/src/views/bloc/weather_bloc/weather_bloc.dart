import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_task/src/model/weather.dart';
import 'package:weather_app_task/src/repository/weather_repo.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _repo;

  WeatherBloc({required WeatherRepository repo})
      : _repo = repo,
        super(const WeatherInitialState()) {
    on<WeatherLoadingEvent>(
      (event, emit) {
        emit(WeatherLoadingState());
      },
    );

    // Get weather by city name
    on<GetWeatherByCityName>(_getWeatherByCityName);

    // Get weather by coordinates
    on<GetWeatherByCoordinates>(_getWeatherByCoordinates);

    on<LocationNotEnabled>(
      (event, emit) {
        emit(const WeatherLocNotEnabledState());
      },
    );

    on<NoInternetConnection>(
      (event, emit) {
        emit(const WeatherNoInternetState("No Internet Connection!!"));
      },
    );

    on<WeatherErrorEvent>(
      (event, emit) {
        emit(WeatherErrorState(event.error));
      },
    );
  }

  Future<void> _getWeatherByCityName(
    GetWeatherByCityName event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      emit(WeatherLoadingState());
      Weather weather = await _repo.getWeatherByCityName(
          cityName: event.cityName, refresh: event.refresh);

      if (event.id == 1) {
        await _repo.updateCity(weather.cityName, 1);
      }

      emit(WeatherLoadedState(weather));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      if (e is SocketException) {
        emit(WeatherNoInternetState(e.message));
        return;
      }
      emit(WeatherErrorState(e.toString()));
    }
  }

  Future<void> _getWeatherByCoordinates(
    GetWeatherByCoordinates event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      emit(WeatherLoadingState());
      Weather weather = await _repo.getWeatherByCoordinates(
        lat: event.latitude,
        lon: event.longitude,
        refresh: event.refresh,
      );

      if (event.id == 0) {
        await _repo.updateCity(weather.cityName, 1);
      }

      emit(WeatherLoadedState(weather));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      if (e is SocketException) {
        emit(WeatherNoInternetState(e.message));
        return;
      }
      emit(WeatherErrorState(e.toString()));
    }
  }
}
