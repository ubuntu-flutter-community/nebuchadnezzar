import 'package:flutter/material.dart';
import 'package:mesh/mesh.dart';

import '../../../../common/view/build_context_x.dart';

class ChatRoomDefaultBackground extends StatelessWidget {
  const ChatRoomDefaultBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final bg = colorScheme.surface;
    final accent = colorScheme.primary;
    return Opacity(
      opacity: 0.3,
      child: OMeshGradient(
        mesh: _createMesh(
          fallbackColor: bg,
          backgroundColor: bg,
          colors: [
            bg.withValues(alpha: 0.01),
            bg.withValues(alpha: 0.01),
            bg.withValues(alpha: 0.01),
            accent.withValues(alpha: 0.11),
            accent.withValues(alpha: 0.31),
            accent.withValues(alpha: 0.11),
            accent.withValues(alpha: 0.02),
            accent.withValues(alpha: 0.41),
            bg.withValues(alpha: 0.71),
            bg.withValues(alpha: 0.91),
            bg.withValues(alpha: 0.80),
            bg,
          ],
        ),
      ),
    );
  }
}

OMeshRect _createMesh({
  required Color? fallbackColor,
  required Color? backgroundColor,
  required List<Color> colors,
}) {
  return OMeshRect(
    width: 3,
    height: 4,
    fallbackColor: fallbackColor,
    backgroundColor: backgroundColor,
    vertices: [
      (0.01, -0.18).v.bezier(
            east: (0.08, -0.01).v,
            south: (-0.06, 0.13).v,
          ),
      (0.6, -0.15).v.bezier(
            east: (0.95, -0.1).v,
            south: (0.67, -0.14).v,
            west: (0.38, -0.2).v,
          ),
      (0.67, -0.27).v.bezier(
            west: (0.54, -0.21).v,
          ), // Row 1
      (-0.03, 0.44).v.bezier(
            north: (-0.03, 0.29).v,
          ),
      (0.6, 0.39).v.bezier(
            north: (0.62, 0.39).v,
            east: (1.01, 0.41).v,
            west: (0.37, 0.37).v,
          ),
      (1.07, 0.07).v.bezier(
            west: (0.96, 0.23).v,
          ), // Row 2
      (-0.03, 0.54).v.bezier(
            east: (0.12, 0.51).v,
            south: (-0.17, 0.58).v,
          ),
      (0.47, 0.52).v.bezier(
            east: (0.68, 0.53).v,
            south: (0.48, 0.54).v,
            west: (0.36, 0.51).v,
          ),
      (1.1, 0.6).v.bezier(
            north: (1.13, 0.53).v,
            south: (1.04, 0.59).v,
            west: (0.97, 0.59).v,
          ), // Row 3
      (-0.0, 1.11).v.bezier(
            north: (-0.28, 0.79).v,
            east: (0.18, 1.06).v,
          ),
      (0.53, 1.08).v.bezier(
            north: (0.56, 0.66).v,
            east: (0.74, 1.11).v,
            west: (0.41, 1.07).v,
          ),
      (1.11, 1.11).v.bezier(
            north: (1.05, 0.61).v,
            west: (1.04, 1.09).v,
          ), // Row 4
    ],
    colors: colors,
  );
}
