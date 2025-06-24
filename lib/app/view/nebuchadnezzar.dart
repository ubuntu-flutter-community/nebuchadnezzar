import 'package:flutter/material.dart';
import 'package:system_theme/system_theme_builder.dart';
import 'package:yaru/yaru.dart';

import '../../common/platforms.dart';
import 'wait_for_registration_page.dart';

class Nebuchadnezzar extends StatelessWidget {
  const Nebuchadnezzar({super.key});

  @override
  Widget build(BuildContext context) => Platforms.isLinux
      ? YaruTheme(
          builder: (context, yaru, child) => WaitForRegistrationPage(
            lightTheme: yaru.theme,
            darkTheme: yaru.darkTheme,
            highContrastTheme: yaruHighContrastLight,
            highContrastDarkTheme: yaruHighContrastDark,
          ),
        )
      : SystemThemeBuilder(
          builder: (context, systemColor) => WaitForRegistrationPage(
            lightTheme: createYaruLightTheme(primaryColor: systemColor.accent),
            darkTheme: createYaruDarkTheme(primaryColor: systemColor.accent),
            highContrastTheme: yaruHighContrastLight,
            highContrastDarkTheme: yaruHighContrastDark,
          ),
        );
}
