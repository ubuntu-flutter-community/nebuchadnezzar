import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/snackbars.dart';
import '../../l10n/l10n.dart';
import '../settings_model.dart';

class ChatSettingsAvatar extends StatelessWidget with WatchItMixin {
  const ChatSettingsAvatar({
    super.key,
    this.dimension,
    this.iconSize,
    this.showEditButton = true,
  });

  final double? dimension;
  final double? iconSize;
  final bool showEditButton;

  @override
  Widget build(BuildContext context) {
    final foreGroundColor = context.colorScheme.isLight
        ? Colors.black
        : Colors.white;
    final l10n = context.l10n;
    final attachingAvatar = watchPropertyValue(
      (SettingsModel m) => m.attachingAvatar,
    );
    final uri = watchStream(
      (SettingsModel m) => m.myProfileStream,
      initialValue: di<SettingsModel>().myProfile,
    ).data?.avatarUrl;

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
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                disabledBackgroundColor: context.colorScheme.surface,
                disabledForegroundColor: foreGroundColor,
              ),
              onPressed: attachingAvatar
                  ? null
                  : () => di<SettingsModel>().setMyProfilAvatar(
                      onFail: (e) => showErrorSnackBar(context, e.toString()),
                      onWrongFileFormat: () =>
                          showSnackBar(context, content: Text(l10n.notAnImage)),
                    ),
              icon: attachingAvatar
                  ? SizedBox.square(
                      dimension: 15,
                      child: Progress(strokeWidth: 2, color: foreGroundColor),
                    )
                  : const Icon(YaruIcons.pen, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
