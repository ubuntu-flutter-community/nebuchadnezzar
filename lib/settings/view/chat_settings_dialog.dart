import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import 'chat_settings_account_section.dart';
import 'chat_settings_customization_section.dart';
import 'chat_settings_devices_section.dart';
import 'chat_settings_events_section.dart';
import 'chat_settings_notifications_page.dart';
import 'chat_settings_security_section.dart';
import 'theme_section.dart';

class ChatSettingsDialog extends StatefulWidget {
  const ChatSettingsDialog({super.key});

  @override
  State<ChatSettingsDialog> createState() => _ChatSettingsDialogState();
}

class _ChatSettingsDialogState extends State<ChatSettingsDialog>
    with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    titlePadding: EdgeInsets.zero,
    title: YaruDialogTitleBar(
      title: YaruTabBar(
        tabController: tabController,
        tabs: [
          Tab(
            child: Row(
              spacing: kSmallPadding,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(YaruIcons.settings),
                Text(context.l10n.settings),
              ],
            ),
          ),
          Tab(
            child: Row(
              spacing: kSmallPadding,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(YaruIcons.bell),
                Text(context.l10n.notifications),
              ],
            ),
          ),
        ],
      ),
      border: BorderSide.none,
      backgroundColor: Colors.transparent,
    ),
    content: SizedBox(
      width: 450,
      height: 600,
      child: TabBarView(
        controller: tabController,
        children: const [
          Center(child: ChatSettingsDialogContent()),
          ChatSettingsNotificationsView(),
        ],
      ),
    ),
  );
}

class ChatSettingsDialogContent extends StatelessWidget {
  const ChatSettingsDialogContent({super.key});

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    child: Column(
      spacing: kBigPadding,
      children: [
        // TODO: check which servers support presence
        // const ChatPresenceButton(),
        ChatSettingsAccountSection(),
        ChatSettingsCustomizationSection(),
        ThemeSection(),
        ChatSettingsEventsSection(),
        ChatSettingsSecuritySection(),
        ChatSettingsDevicesSection(),
      ],
    ),
  );
}
