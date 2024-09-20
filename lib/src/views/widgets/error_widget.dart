import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../utils/assets.dart';

class CustomErrorWidget extends StatelessWidget {
  final String svgPath;
  final String error;

  const CustomErrorWidget({super.key, required this.svgPath, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.errorSvg, height: 250),
            const Gap(16.0),
            Text(error, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
