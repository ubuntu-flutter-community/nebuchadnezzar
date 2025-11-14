import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../settings/account_manager.dart';
import '../../settings/view/chat_settings_avatar.dart';

class ChatMasterSettingsTileAvatar extends StatefulWidget
    with WatchItStatefulWidgetMixin {
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
    _profileFuture = di<AccountManager>().getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    final syncStatus = watchStream(
      (ChatManager m) => m.syncStatusUpdateStream,
      initialValue: di<ChatManager>().syncStatusUpdate,
    ).data;

    final widget = switch (syncStatus?.status) {
      SyncStatus.error => Tooltip(
        key: const ValueKey('0'),
        message: syncStatus?.error?.exception?.toString() ?? '',
        child: Icon(YaruIcons.error, color: context.theme.colorScheme.error),
      ),
      SyncStatus.cleaningUp => const Center(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Progress(strokeWidth: 2),
        ),
      ),
      _ => FutureBuilder(
        key: const ValueKey('2'),
        future: _profileFuture,
        builder: (context, asyncSnapshot) {
          return ChatSettingsAvatar(
            key: ValueKey(asyncSnapshot.data?.avatarUrl ?? 'master_avatar'),
            profile: asyncSnapshot.hasError ? null : asyncSnapshot.data,
            dimension: 25,
            showEditButton: false,
          );
        },
      ),
    };
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: SizedBox.square(dimension: 25, child: widget),
    );
  }
}
