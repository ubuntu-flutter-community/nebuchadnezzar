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

  Icon getIcon(ColorScheme colorScheme) => switch (this) {
        PushRuleState.mentionsOnly => const Icon(YaruIcons.speaker_high),
        PushRuleState.notify => const Icon(YaruIcons.speaker_high_filled),
        PushRuleState.dontNotify => const Icon(YaruIcons.speaker_muted),
      };

  IconData getIconData() => switch (this) {
        PushRuleState.mentionsOnly => YaruIcons.speaker_high,
        PushRuleState.notify => YaruIcons.speaker_high_filled,
        PushRuleState.dontNotify => YaruIcons.speaker_muted,
      };
}
