import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WeatherApi {
  final Client client;

  const WeatherApi({required this.client});

  /// API Key
  final _apiKey = "YOUR_API_KEY";

  /// Base URL
  final _baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Response> getWeatherByCityName(String cityName) async {
    try {
      Response response =
          await client.get(Uri.parse("$_baseUrl?q=$cityName&appid=$_apiKey"));

      if (response.statusCode == HttpStatus.ok) {
        debugPrint(response.body);
        return response;
      } else if (response.statusCode == HttpStatus.notFound) {
        throw 'No Data Found for $cityName.\nPlease enter valid city name';
      } else {
        throw 'Failed to get weather data.\nStatus code: ${response.statusCode}';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getWeatherByCoordinates(double lon, double lat) async {
    try {
      final uri = Uri.parse("$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey");

      Response response = await client.get(uri);

      if (response.statusCode == 200) {
        debugPrint(response.body);
        return response;
      } else if (response.statusCode == HttpStatus.notFound) {
        throw 'No Data Found for you current location.\nPlease try again';
      } else {
        throw 'Failed to get weather data.\nStatus code: ${response.statusCode}';
      }
    } catch (e) {
      rethrow;
    }
  }
}
