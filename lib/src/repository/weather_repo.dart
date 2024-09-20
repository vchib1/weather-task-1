import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart%20';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_task/src/model/weather.dart';
import 'package:weather_app_task/src/source/local/app_db.dart';
import 'package:weather_app_task/src/source/remote/weather_api.dart';
import 'package:weather_app_task/src/utils/unit_enum.dart';

abstract class WeatherRepository {
  const WeatherRepository();

  Future<Weather> getWeatherByCityName(
      {required String cityName, bool refresh = false});

  Future<Weather> getWeatherByCoordinates(
      {required double lon, required double lat, bool refresh = false});

  Stream<List<String>> getCitiesList();

  Future<int> addCity(String cityName);

  Future<int> updateCity(String cityName, int id);

  Future<int> deleteCity(String cityName);

  Future<bool> setSelectedIndex(int index);

  Future<int> getSelectedIndex();

  Future<bool> setTempUnit(TempUnit unit);

  Future<TempUnit> getTempUnit();
}

class WeatherRepoImpl implements WeatherRepository {
  const WeatherRepoImpl({
    required this.db,
    required this.api,
    required this.prefs,
  });

  final AppDatabase db;
  final WeatherApi api;
  final SharedPreferences prefs;

  @override
  Future<TempUnit> getTempUnit() async {
    return TempUnit.parse(prefs.getString("tempUnit") ?? "celsius");
  }

  @override
  Future<bool> setTempUnit(TempUnit unit) async {
    return prefs.setString("tempUnit", unit.name);
  }

  @override
  Future<int> getSelectedIndex() async {
    return prefs.getInt('selectedIndex') ?? 0;
  }

  @override
  Future<bool> setSelectedIndex(int index) async {
    return prefs.setInt('selectedIndex', index);
  }

  @override
  Future<int> addCity(String cityName) => db.insertCity(cityName);

  @override
  Future<int> updateCity(String cityName, int id) =>
      db.updateCity(cityName, id);

  @override
  Future<int> deleteCity(String cityName) => db.deleteCity(cityName);

  @override
  Stream<List<String>> getCitiesList() => db.getCities();

  @override
  Future<Weather> getWeatherByCityName(
      {required String cityName, bool refresh = false}) async {
    try {
      if (!refresh) {
        Map<String, dynamic>? cachedData = await db.getWeatherCache(cityName);

        if (cachedData != null) {
          debugPrint("Cached Data : City Name : $cityName");
          return Weather.fromMap(cachedData);
        }
      }

      Response response = await api.getWeatherByCityName(cityName);

      debugPrint(response.reasonPhrase);

      if (response.statusCode == HttpStatus.ok) {
        Weather weather = Weather.fromMap(jsonDecode(response.body));
        await db.insertWeatherCache(cityName, weather);
        debugPrint("API Data : City Name : $cityName");
        return weather;
      } else {
        throw 'Failed to get weather data';
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Weather> getWeatherByCoordinates(
      {required double lon, required double lat, bool refresh = false}) async {
    try {
      if (!refresh) {
        Map<String, dynamic>? cachedData =
            await db.getWeatherCache("coordindates");

        if (cachedData != null) {
          debugPrint("Cached Data");
          return Weather.fromMap(cachedData);
        }
      }

      Response response = await api.getWeatherByCoordinates(lon, lat);

      if (response.statusCode == HttpStatus.ok) {
        Weather weather = Weather.fromMap(jsonDecode(response.body));
        await db.insertWeatherCache("coordindates", weather);
        debugPrint("API Data");
        return weather;
      } else {
        throw Exception('Failed to get weather data');
      }
    } catch (_) {
      rethrow;
    }
  }
}
