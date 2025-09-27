import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/common_widgets.dart';
import '../../l10n/l10n.dart';
import '../settings_manager.dart';

class ChatSettingsEventsSection extends StatelessWidget with WatchItMixin {
  const ChatSettingsEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsManager = di<SettingsManager>();

    return YaruSection(
      headline: Text(l10n.showTheseEventsInTheChat),
      child: Column(
        children: [
          YaruTile(
            title: Text(l10n.changedTheChatAvatar('"UserABC"')),
            trailing: CommonSwitch(
              value: watchPropertyValue(
                (SettingsManager m) => m.showChatAvatarChanges,
              ),
              onChanged: settingsManager.setShowAvatarChanges,
            ),
          ),
          YaruTile(
            title: Text(l10n.changedTheDisplaynameTo('"UserABC"', '"UserXYZ"')),
            trailing: CommonSwitch(
              value: watchPropertyValue(
                (SettingsManager m) => m.showChatDisplaynameChanges,
              ),
              onChanged: settingsManager.setShowChatDisplaynameChanges,
            ),
          ),
        ],
      ),
    );
  }
}
