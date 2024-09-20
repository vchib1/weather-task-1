import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_task/src/utils/assets.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LottieBuilder.asset(Assets.loadingAnimationJson, height: 250),
          Text("Loading...", style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
