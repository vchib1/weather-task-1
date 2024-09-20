import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_task/di.dart';
import 'package:weather_app_task/src/views/bloc/weather_bloc/weather_bloc.dart';
import 'package:weather_app_task/src/views/home_page.dart';

import 'src/views/bloc/city_bloc/city_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  await di.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const AppBlocProvider(child: HomePage()),
    );
  }
}

class AppBlocProvider extends StatelessWidget {
  final Widget child;

  const AppBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // HomeBloc
        BlocProvider(
          create: (context) => CityBloc(repo: di())..add(GetCitiesEvent()),
        ),

        BlocProvider(
          create: (context) => WeatherBloc(repo: di()),
        ),
      ],
      child: child,
    );
  }
}
