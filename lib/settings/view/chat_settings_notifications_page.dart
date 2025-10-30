// ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/ui_constants.dart';
import '../../extensions/push_rule_extension.dart';
import '../../l10n/l10n.dart';
import '../account_manager.dart';
import 'chat_settings_push_rule_tile.dart';
import 'chat_settings_pusher_list.dart';

class ChatSettingsNotificationsView extends StatelessWidget with WatchItMixin {
  const ChatSettingsNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final pushCategories = di<AccountManager>().pushCategories;
    watchStream((AccountManager m) => m.pushRulesStream, preserveState: false);

    return Column(
      spacing: kBigPadding,
      mainAxisSize: MainAxisSize.min,
      children: [
        YaruSection(
          headline: Text(context.l10n.pusherDevices),
          child: const ChatSettingsPusherList(),
        ),
        Flexible(
          child: YaruExpansionPanel(
            shrinkWrap: true,
            isInitiallyExpanded: pushCategories
                .mapIndexed((i, e) => i == 0)
                .toList(),
            headers: pushCategories
                .map(
                  (e) => Text(
                    e.kind.localized(context.l10n),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
                .toList(),
            children: [
              for (final category in pushCategories)
                Column(
                  children: [
                    for (final rule in category.rules)
                      ChatSettingsPushRuleTile(rule: rule, kind: category.kind),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
