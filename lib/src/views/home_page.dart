import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_task/src/model/weather.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:weather_app_task/src/utils/assets.dart';
import 'package:weather_app_task/src/utils/unit_enum.dart';
import 'package:weather_app_task/src/views/add_city_page.dart';
import 'package:weather_app_task/src/views/bloc/weather_bloc/weather_bloc.dart';
import 'bloc/city_bloc/city_bloc.dart';
import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  late StreamSubscription<CityState> _subscription;

  @override
  void initState() {
    final homeBloc = context.read<CityBloc>();
    _subscription = homeBloc.stream.listen(
      (state) {
        if (state is CityLoadedState && mounted) {
          selectedIndex = state.selectedIndex;
          _refresh(state);
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _refresh(CityLoadedState state, [bool refresh = false]) async {
    final weatherBloc = context.read<WeatherBloc>();

    // Check if the selected city is "Use Current Location" or if a refresh is requested
    if ((state.selectedIndex == 0 &&
        state.cities.first == "Use Current Location")) {
      debugPrint("Loading weather data...");
      weatherBloc.add(WeatherLoadingEvent());

      try {
        debugPrint("getting location...");
        final position = await _determinePosition();

        List<Placemark> places = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        final city = places.first.locality;

        if (city != null && city.isNotEmpty) {
          debugPrint("getting city data index 0...");
          weatherBloc.add(GetWeatherByCityName(city, 1, refresh));
        } else {
          debugPrint("getting city data coordinates...");
          return weatherBloc.add(
            GetWeatherByCoordinates(position.latitude, position.longitude, 1),
          );
        }

        weatherBloc.add(const WeatherErrorEvent("ERROR"));
      } catch (error, stack) {
        debugPrintStack(stackTrace: stack);
        if (error is SocketException) {
          return weatherBloc.add(NoInternetConnection());
        }

        weatherBloc.add(LocationNotEnabled());
      }
    } else {
      debugPrint("getting city data...");
      weatherBloc.add(
        GetWeatherByCityName(state.cities[state.selectedIndex], -1, refresh),
      );
    }
  }

  void navigateToAddCity() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<CityBloc>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<WeatherBloc>(context),
            ),
          ],
          child: AddCityPage(
            onTap: (index) {
              selectedIndex = index;
              if (context.read<CityBloc>().state is CityLoadedState) {
                final state = context.read<CityBloc>().state as CityLoadedState;
                context.read<CityBloc>().add(
                    UpdateStateEvent(state.copyWith(selectedIndex: index)));
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              switch (state) {
                case WeatherInitialState():
                case WeatherLoadingState():
                  return const CustomLoadingWidget();
                case WeatherNoInternetState():
                  return NoInternetWidget(
                    error: state.error,
                    onTap: () async {
                      if (context.read<CityBloc>().state is CityLoadedState) {
                        final homeState =
                            context.read<CityBloc>().state as CityLoadedState;

                        _refresh(homeState, true);
                      }
                    },
                  );
                case WeatherErrorState():
                  return RefreshIndicator(
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    onRefresh: () async {
                      if (context.read<CityBloc>().state is CityLoadedState) {
                        final homeState =
                            context.read<CityBloc>().state as CityLoadedState;

                        _refresh(homeState, true);
                      }
                    },
                    child: CustomErrorWidget(
                      svgPath: Assets.errorSvg,
                      error: state.error,
                    ),
                  );
                case WeatherLocNotEnabledState():
                  return EnableLocationWidget(
                    onTap: () async {
                      if (context.read<CityBloc>().state is CityLoadedState) {
                        final homeState =
                            context.read<CityBloc>().state as CityLoadedState;

                        _refresh(homeState, true);
                      }
                    },
                  );
                case WeatherLoadedState():
                  Weather weather = state.weather;
                  return BlocBuilder<CityBloc, CityState>(
                    builder: (context, state) {
                      if (state is CityLoadedState) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            _refresh(state, true);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                opacity: 0.75,
                                image: AssetImage(
                                  Assets.getWeatherBackground(
                                      code: weather.icon),
                                ),
                              ),
                            ),
                            child: CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  pinned: true,
                                  expandedHeight: 100,
                                  centerTitle: false,
                                  backgroundColor: Colors.transparent,
                                  flexibleSpace: FlexibleSpaceBar(
                                    titlePadding:
                                        const EdgeInsetsDirectional.only(
                                            start: 16.0, bottom: 8.0),
                                    title: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // Align to the left
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          weather.cityName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(fontSize: 24),
                                        ),
                                        const Gap(2.0),
                                        Text(
                                          "Updated ${timeago.format(weather.date)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      const Gap(50.0),
                                      WeatherWidget(
                                        weather: weather,
                                        useCelsius: state.selectedUnit ==
                                            TempUnit.celsius,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () => navigateToAddCity(),
                  icon: const Icon(Icons.more_vert)),
            ),
          ),
        ],
      ),
    );
  }
}
