import 'package:flutter/material.dart';
import 'package:matrix/matrix_api_lite/generated/model.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../authentication/authentication_model.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../account_model.dart';
import 'chat_settings_avatar.dart';
import 'chat_settings_display_name_text_field.dart';
import 'chat_settings_logout_button.dart';

class ChatSettingsAccountSection extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatSettingsAccountSection({super.key});

  @override
  State<ChatSettingsAccountSection> createState() =>
      _ChatSettingsAccountSectionState();
}

class _ChatSettingsAccountSectionState
    extends State<ChatSettingsAccountSection> {
  late Future<Profile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = di<AccountModel>().getMyProfile();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _profileFuture,
    builder: (context, asyncSnapshot) => YaruSection(
      headline: Text(context.l10n.account),
      child: Column(
        children: [
          ChatSettingsAvatar(
            key: ValueKey(asyncSnapshot.data?.avatarUrl ?? 'settings_avatar'),
            dimension: 100,
            iconSize: 70,
            profile: asyncSnapshot.hasError ? null : asyncSnapshot.data,
          ),
          const SizedBox(height: kBigPadding),
          YaruTile(
            title: ChatSettingsDisplayNameTextField(
              profile: asyncSnapshot.hasError ? null : asyncSnapshot.data,
            ),
          ),
          YaruTile(
            title: TextField(
              enabled: false,
              controller: TextEditingController(
                text: di<AuthenticationModel>().loggedInUserId,
              ),
            ),
            trailing: const ChatSettingsLogoutButton(),
          ),
        ],
      ),
    ),
  );
}
