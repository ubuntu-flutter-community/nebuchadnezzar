import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

import 'build_context_x.dart';
import 'ui_constants.dart';

class CircleWaveLoader extends StatelessWidget {
  const CircleWaveLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(seconds: 5),
        height: context.mediaQuerySize.height / 2,
        width: (context.mediaQuerySize.width - kSideBarWith) / 2,
        child: Transform.rotate(
          angle: pi * 3 / 2,
          child: LiquidCircularProgressIndicator(
            borderColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            borderWidth: 0,
            direction: Axis.horizontal,
            valueColor: AlwaysStoppedAnimation(
              context.colorScheme.primary.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
