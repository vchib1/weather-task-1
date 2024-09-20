import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../utils/assets.dart';

class EnableLocationWidget extends StatelessWidget {

  final void Function() onTap;

  const EnableLocationWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.locationIllustrationSvg,
            height: 250,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const Gap(16.0),
          MaterialButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: onTap,
            child: Text(
              "Allow Location Access",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
