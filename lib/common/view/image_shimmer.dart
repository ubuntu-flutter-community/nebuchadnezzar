import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yaru/yaru.dart';

import 'build_context_x.dart';

class ImageShimmer extends StatelessWidget {
  const ImageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Center(
      child: Shimmer.fromColors(
        baseColor: theme.cardColor,
        highlightColor: theme.colorScheme.isLight
            ? theme.cardColor.scale(lightness: -0.1)
            : theme.cardColor.scale(lightness: 0.05),
        child: Container(
          color: theme.cardColor,
        ),
      ),
    );
  }
}
