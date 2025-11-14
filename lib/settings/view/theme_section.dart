import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../settings_manager.dart';
import 'theme_tile.dart';

class ThemeSection extends StatelessWidget with WatchItMixin {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsManager = di<SettingsManager>();
    final l10n = context.l10n;
    final themeIndex = watchPropertyValue(
      (SettingsManager m) => m.themModeIndex,
    );

    return YaruSection(
      headline: Text(l10n.changeTheme),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: kBigPadding),
              child: Wrap(
                spacing: kBigPadding,
                children: [
                  for (var i = 0; i < ThemeMode.values.length; ++i)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        YaruSelectableContainer(
                          padding: const EdgeInsets.all(1),
                          borderRadius: BorderRadius.circular(15),
                          selected: themeIndex == i,
                          onTap: () => settingsManager.setThemModeIndex(i),
                          selectionColor: context.theme.colorScheme.primary,
                          child: ThemeTile(ThemeMode.values[i]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ThemeMode.values[i].localize(context.l10n),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension ThemeModeX on ThemeMode {
  String localize(AppLocalizations l10n) => switch (this) {
    ThemeMode.system => l10n.systemTheme,
    ThemeMode.dark => l10n.darkTheme,
    ThemeMode.light => l10n.lightTheme,
  };
}
