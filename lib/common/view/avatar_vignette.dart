import 'package:flutter/material.dart';

import 'build_context_x.dart';
import 'theme.dart';

class AvatarVignette extends StatelessWidget {
  const AvatarVignette({
    super.key,
    required this.borderRadius,
    required this.child,
    this.dimension,
    this.fallBackColor,
  });

  final double? dimension;
  final BorderRadius borderRadius;
  final Widget child;
  final Color? fallBackColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: fallBackColor ??
              getMonochromeBg(
                theme: context.theme,
                factor: 6,
                darkFactor: 20,
              ),
          child: child,
        ),
      ),
    );
  }
}
