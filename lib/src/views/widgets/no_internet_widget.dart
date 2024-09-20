import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../utils/assets.dart';

class NoInternetWidget extends StatelessWidget {
  final String error;
  final void Function() onTap;

  const NoInternetWidget({super.key, required this.onTap, required this.error});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.noInternetSvg,
            height: 250,
          ),
          const Gap(16.0),
          Text(
            error,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const Gap(16.0),
          MaterialButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: onTap,
            child: Text(
              "Refresh",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
