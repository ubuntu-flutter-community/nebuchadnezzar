import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/common_widgets.dart';
import '../../l10n/l10n.dart';
import '../settings_model.dart';

class ChatSettingsEventsSection extends StatelessWidget with WatchItMixin {
  const ChatSettingsEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsModel = di<SettingsModel>();

    return YaruSection(
      // TODO: localize
      headline: const Text('Show these events in the chat'),
      child: Column(
        children: [
          YaruTile(
            title: Text(l10n.changedTheChatAvatar('"UserABC"')),
            trailing: CommonSwitch(
              value: watchPropertyValue(
                (SettingsModel m) => m.showChatAvatarChanges,
              ),
              onChanged: settingsModel.setShowAvatarChanges,
            ),
          ),
          YaruTile(
            title: Text(l10n.changedTheDisplaynameTo('"UserABC"', '"UserXYZ"')),
            trailing: CommonSwitch(
              value: watchPropertyValue(
                (SettingsModel m) => m.showChatDisplaynameChanges,
              ),
              onChanged: settingsModel.setShowChatDisplaynameChanges,
            ),
          ),
        ],
      ),
    );
  }
}
