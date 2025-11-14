import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/chat_avatar.dart';
import '../../l10n/l10n.dart';
import '../account_manager.dart';

class ChatSettingsAvatar extends StatelessWidget with WatchItMixin {
  const ChatSettingsAvatar({
    super.key,
    this.dimension,
    this.iconSize,
    this.showEditButton = true,
    required this.profile,
  });

  final double? dimension;
  final double? iconSize;
  final bool showEditButton;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final uri = watchStream(
      (AccountManager m) => m.myProfileStream.map((e) => e?.avatarUrl),
      initialValue: profile?.avatarUrl,
    ).data;

    return Stack(
      children: [
        ChatAvatar(
          avatarUri: uri,
          dimension: dimension ?? 38,
          fallBackIconSize: iconSize,
        ),
        if (showEditButton)
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton.filled(
              onPressed: () => showFutureLoadingDialog(
                context: context,
                future: () => di<AccountManager>().setMyProfilAvatar(
                  wrongFileFormat: l10n.notAnImage,
                ),
              ),
              icon: const Icon(YaruIcons.pen, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
