import 'package:get_it/get_it.dart';
import 'package:http/http.dart%20';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_task/src/repository/weather_repo.dart';

import 'src/source/local/app_db.dart';
import 'src/source/remote/weather_api.dart';

GetIt di = GetIt.instance;

Future<void> init() async {
  final Client client = Client();

  // SHARED PREFERENCES
  di.registerSingletonAsync<SharedPreferences>(
    () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs;
    },
  );

  // APP DATABASE
  di.registerLazySingleton<AppDatabase>(() => AppDatabase());

  di.registerLazySingleton<WeatherApi>(() => WeatherApi(client: client));

  di.registerLazySingleton<WeatherRepository>(() => WeatherRepoImpl(
      db: di<AppDatabase>(),
      api: di<WeatherApi>(),
      prefs: di<SharedPreferences>()));
}
