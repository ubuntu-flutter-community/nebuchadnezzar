import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../l10n/app_localizations.dart';

extension PushRuleStateX on PushRuleState {
  String localize(AppLocalizations l10n) => switch (this) {
    PushRuleState.dontNotify => l10n.muteChat,
    PushRuleState.notify => '${l10n.notifyMeFor}: ${l10n.all}',
    PushRuleState.mentionsOnly => '${l10n.notifyMeFor}: ${l10n.mention}',
  };

  Widget getIcon(ColorScheme colorScheme) => switch (this) {
    PushRuleState.mentionsOnly => const Icon(YaruIcons.notification),
    PushRuleState.notify => const Icon(YaruIcons.notification_filled),
    PushRuleState.dontNotify => Stack(
      alignment: Alignment.center,
      children: [
        const Icon(YaruIcons.notification),
        Icon(YaruIcons.window_close, size: 10, color: colorScheme.onSurface),
      ],
    ),
  };

  IconData getIconData() => switch (this) {
    PushRuleState.mentionsOnly => YaruIcons.speaker_high,
    PushRuleState.notify => YaruIcons.speaker_high_filled,
    PushRuleState.dontNotify => YaruIcons.speaker_muted,
  };
}
