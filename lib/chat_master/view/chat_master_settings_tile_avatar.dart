import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../settings/account_model.dart';
import '../../settings/view/chat_settings_avatar.dart';

class ChatMasterSettingsTileAvatar extends StatefulWidget {
  const ChatMasterSettingsTileAvatar({super.key});

  @override
  State<ChatMasterSettingsTileAvatar> createState() =>
      _ChatMasterSettingsTileAvatarState();
}

class _ChatMasterSettingsTileAvatarState
    extends State<ChatMasterSettingsTileAvatar> {
  late Future<Profile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = di<AccountModel>().getMyProfile();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _profileFuture,
    builder: (context, asyncSnapshot) {
      return ChatSettingsAvatar(
        key: ValueKey(asyncSnapshot.data?.avatarUrl ?? 'master_avatar'),
        profile: asyncSnapshot.hasError ? null : asyncSnapshot.data,
        dimension: 25,
        showEditButton: false,
      );
    },
  );
}
