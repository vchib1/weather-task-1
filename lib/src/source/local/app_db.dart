import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weather_app_task/src/model/weather.dart';

const String _weatherCache = 'weatherCache';
const String _cities = 'cities';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._();

  static Database? database;

  factory AppDatabase() {
    return instance;
  }

  AppDatabase._();

  Future<Database> getDatabase() async {
    database ??= await _initDatabase("app.db");
    return database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // CREATE TABLE
    await db.execute(
      "CREATE TABLE IF NOT EXISTS $_cities (id INTEGER PRIMARY KEY AUTOINCREMENT, city TEXT)",
    );

    final defaultCities = [
      "Use Current Location",
      "Delhi",
      "Tokyo",
      "Moscow",
      "Paris",
      "Sydney"
    ];
    String values = defaultCities.map((str) => '("$str")').join(',');
    await db.rawInsert("INSERT INTO $_cities (city) VALUES $values");

    await db.execute(
      "CREATE TABLE IF NOT EXISTS $_weatherCache (city TEXT PRIMARY KEY, jsonData TEXT , createdAt TEXT)",
    );
  }

  Future<int> insertCity(String city) async {
    try {
      Database db = await instance.getDatabase();
      int res = await db.insert(
        _cities,
        {"city": city},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return res;
    } catch (e) {
      debugPrint("Error in insertCity, Reason: $e");
      return 0;
    }
  }

  Future<int> updateCity(String city, int id) async {
    try {
      Database db = await instance.getDatabase();
      int res = await db.update(
        _cities,
        {"city": city},
        where: "id = ?",
        whereArgs: [id],
      );
      return res;
    } catch (e) {
      debugPrint("Error in insertCity, Reason: $e");
      return 0;
    }
  }

  Future<int> deleteCity(String city) async {
    try {
      Database db = await instance.getDatabase();
      int res = await db.delete(
        _cities,
        where: "city = ?",
        whereArgs: [city],
      );
      await db.delete(_weatherCache, where: "city = ?", whereArgs: [city]);
      return res;
    } catch (e) {
      debugPrint("Error in deleteCity, Reason: $e");
      return 0;
    }
  }

  Stream<List<String>> getCities() async* {
    Database db = await instance.getDatabase();
    List<Map<String, dynamic>> res = await db.query(_cities);

    yield res.map((e) => e['city'] as String).toList();
  }

  Future<int> insertWeatherCache(String city, Weather weather) async {
    try {
      Database db = await instance.getDatabase();

      Map<String, dynamic> values = {
        "city": city,
        "createdAt": DateTime.now().toIso8601String(),
        "jsonData": jsonEncode(weather.toMap()),
      };

      int res = await db.insert(
        _weatherCache,
        values,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return res;
    } catch (e) {
      debugPrint("Error in insertWeatherCache, Reason: $e");
      return 0;
    }
  }

  Future<Map<String, dynamic>?> getWeatherCache(
    String cityName, {
    int cacheTimeInHours = 1,
  }) async {
    try {
      Database db = await instance.getDatabase();

      final now = DateTime.now();
      final startTime = now.subtract(Duration(hours: cacheTimeInHours));

      List<Map<String, dynamic>> maps = await db.query(
        _weatherCache,
        where: "city = ? AND createdAt BETWEEN ? AND ?",
        whereArgs: [
          cityName,
          startTime.toIso8601String(),
          now.toIso8601String()
        ],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      String jsonData = maps.first["jsonData"] as String;

      final Map<String, dynamic> map = jsonDecode(jsonData);
      return map;
    } catch (e, s) {
      debugPrintStack(label: "Database", stackTrace: s);
      return null;
    }
  }
}
