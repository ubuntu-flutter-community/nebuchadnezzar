import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/snackbars.dart';
import '../../../l10n/l10n.dart';
import '../../settings/settings_model.dart';
import '../../common/view/chat_avatar.dart';

class ChatMyUserAvatar extends StatelessWidget with WatchItMixin {
  const ChatMyUserAvatar({
    super.key,
    this.dimension,
    this.iconSize,
    this.uri,
  });

  final double? dimension;
  final double? iconSize;
  final Uri? uri;

  @override
  Widget build(BuildContext context) {
    const foreGroundColor = Colors.white;
    final l10n = context.l10n;
    final attachingAvatar =
        watchPropertyValue((SettingsModel m) => m.attachingAvatar);
    return Stack(
      children: [
        ChatAvatar(
          avatarUri: uri,
          dimension: dimension ?? 38,
          fallBackIconSize: iconSize,
        ),
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
                      onFail: (e) => showErrorSnackBar(context, e),
                      onWrongFileFormat: () => showSnackBar(
                        context,
                        content: Text(l10n.notAnImage),
                      ),
                    ),
            icon: attachingAvatar
                ? const SizedBox.square(
                    dimension: 15,
                    child: Progress(
                      strokeWidth: 2,
                      color: foreGroundColor,
                    ),
                  )
                : const Icon(
                    YaruIcons.pen,
                    color: foreGroundColor,
                  ),
          ),
        ),
      ],
    );
  }
}
