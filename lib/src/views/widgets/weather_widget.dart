import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_task/src/model/weather.dart';
import 'package:weather_app_task/src/utils/extensions/date_time.dart';
import 'package:weather_app_task/src/utils/extensions/double.dart';

import '../../utils/assets.dart';

class WeatherWidget extends StatelessWidget {
  final bool useCelsius;
  final Weather weather;

  const WeatherWidget(
      {super.key, required this.weather, this.useCelsius = true});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final celsiusOrFarehnheit = useCelsius ? "°C" : "°F";

    return Stack(
      children: [
        Opacity(
          opacity: .75,
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: .6,
                child: Lottie.asset(
                  Assets.getAnimation(code: weather.icon),
                  height: 300,
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /// WEATHER TEMP & CONDITION
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: weather.temp.toTempString(useCelsius),
                      style: textTheme.headlineLarge!.copyWith(fontSize: 100),
                      children: [
                        TextSpan(
                          text: celsiusOrFarehnheit,
                          style: textTheme.displaySmall!.copyWith(
                            fontSize: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(2.0),
                  Text(
                    weather.main.toUpperCase(),
                    style: textTheme.titleLarge!.copyWith(fontSize: 30),
                  ),
                  const Gap(2.0),
                  Text(
                    "↑ ${weather.tempMax.toTempString(useCelsius)}$celsiusOrFarehnheit\t\t\t\t↓ ${weather.tempMin.toTempString(useCelsius)}$celsiusOrFarehnheit",
                    style: textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Gap(4.0),
                  Text(
                    weather.date.toStringWithFormat(),
                    style: textTheme.titleLarge,
                  ),
                ],
              ),
            ),

            const Gap(100),

            /// HUMIDITY , WIND , FEELS LIKE
            Container(
              margin: const EdgeInsets.all(8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  weatherInfoWidget(
                    context,
                    svgUrl: Assets.humiditySvg,
                    title: "HUMIDITY",
                    weatherText: "${weather.humidity}%",
                  ),
                  weatherInfoWidget(
                    context,
                    svgUrl: Assets.windSvg,
                    title: "WIND",
                    weatherText: "${(weather.speed.toWindSpeedKpm)} km/h",
                  ),
                  weatherInfoWidget(
                    context,
                    svgUrl: Assets.feelsLikeSvg,
                    title: "FEELS LIKE",
                    weatherText:
                        "${weather.feelsLike.toTempString(useCelsius)}$celsiusOrFarehnheit",
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

Widget weatherInfoWidget(BuildContext context,
    {required String title,
    required String svgUrl,
    required String weatherText}) {
  final textTheme = Theme.of(context).textTheme;

  return Column(
    children: [
      SvgPicture.asset(
        svgUrl,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      const Gap(8.0),
      Text(
        title,
        style: textTheme.titleSmall,
      ),
      const Gap(2.0),
      Text(
        weatherText,
        textAlign: TextAlign.center,
        style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
    ],
  );
}
