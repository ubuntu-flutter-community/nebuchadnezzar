import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/chat_avatar.dart';
import '../../l10n/l10n.dart';
import '../account_model.dart';

class ChatSettingsAvatar extends StatefulWidget
    with WatchItStatefulWidgetMixin {
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
  State<ChatSettingsAvatar> createState() => _ChatSettingsAvatarState();
}

class _ChatSettingsAvatarState extends State<ChatSettingsAvatar> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final uri = watchStream(
      (AccountModel m) => m.myProfileStream.map((e) => e?.avatarUrl),
      initialValue: widget.profile?.avatarUrl,
    ).data;

    return Stack(
      children: [
        ChatAvatar(
          avatarUri: uri,
          dimension: widget.dimension ?? 38,
          fallBackIconSize: widget.iconSize,
        ),
        if (widget.showEditButton)
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton.filled(
              onPressed: () => showFutureLoadingDialog(
                context: context,
                future: () => di<AccountModel>().setMyProfilAvatar(
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
