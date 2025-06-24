import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import 'chat_settings_account_section.dart';
import 'chat_settings_avatar.dart';
import 'chat_settings_customization_section.dart';
import 'chat_settings_devices_section.dart';
import 'chat_settings_events_section.dart';
import 'theme_section.dart';

class ChatSettingsDialog extends StatelessWidget with WatchItMixin {
  const ChatSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    titlePadding: EdgeInsets.zero,
    title: YaruDialogTitleBar(
      title: Text(context.l10n.settings),
      border: BorderSide.none,
      backgroundColor: Colors.transparent,
    ),
    scrollable: true,
    content: const SizedBox(
      width: 450,
      child: Column(
        spacing: kBigPadding,
        children: [
          ChatSettingsAvatar(dimension: 100, iconSize: 70),
          // TODO: check which servers support presence
          // const ChatPresenceButton(),
          ChatSettingsAccountSection(),
          ChatSettingsCustomizationSection(),
          ThemeSection(),
          ChatSettingsEventsSection(),
          ChatSettingsDevicesSection(),
        ],
      ),
    ),
  );
}
