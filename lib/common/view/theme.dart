import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'ui_constants.dart';

bool yaru = !kIsWeb && (Platform.isLinux || Platform.isMacOS);

Color remixColor(
  Color targetColor, {
  List<Color> palette = Colors.accents,
}) {
  double minDistance = double.infinity;
  Color closestColor = palette[0];

  for (Color color in palette) {
    double distance = colorDistance(targetColor, color);
    if (distance < minDistance) {
      minDistance = distance;
      closestColor = color;
    }
  }

  return closestColor;
}

double colorDistance(Color color1, Color color2) {
  int rDiff = color1.r.toInt() - color2.r.toInt();
  int gDiff = color1.g.toInt() - color2.g.toInt();
  int bDiff = color1.b.toInt() - (color2.b * 0.4).toInt();
  return sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff);
}

Color getTileColor(
  bool isUserEvent,
  ThemeData theme,
) {
  final userColor = theme.colorScheme.primary == YaruColors.orange
      ? theme.colorScheme.link.scale(
          saturation: theme.colorScheme.isLight ? -0.5 : -0.7,
          lightness: theme.colorScheme.isLight ? 0.85 : -0.5,
        )
      : theme.colorScheme.primary.scale(
          saturation: theme.colorScheme.isLight ? (yaru ? -0.3 : -0.6) : -0.6,
          lightness: theme.colorScheme.isLight ? 0.65 : (yaru ? -0.5 : -0.7),
        );

  return isUserEvent
      ? userColor
      : getMonochromeBg(theme: theme, factor: 6, darkFactor: 15);
}

Color getPanelBg(ThemeData theme) =>
    getMonochromeBg(theme: theme, darkFactor: 3);

Color getMonochromeBg({
  required ThemeData theme,
  double factor = 1.0,
  double? darkFactor,
  double? lightFactor,
}) =>
    theme.colorScheme.surface.scale(
      lightness: (theme.colorScheme.isLight ? -0.02 : 0.005) *
          (theme.colorScheme.isLight
              ? lightFactor ?? factor
              : darkFactor ?? factor),
    );

Color getEventBadgeColor(ThemeData theme) =>
    theme.colorScheme.onSurface.withValues(alpha: 0.2);

Color getEventBadgeTextColor(ThemeData theme) => theme.colorScheme.onSurface;

EdgeInsets tilePadding(bool partOfMessageCohort) {
  return const EdgeInsets.symmetric(
    horizontal: kSmallPadding,
    vertical: kTinyPadding,
  );
}

ButtonStyle get textFieldSuffixStyle => IconButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
      ),
    );

Color avatarFallbackColor(ColorScheme colorScheme) =>
    colorScheme.primary.withValues(alpha: 0.3);
