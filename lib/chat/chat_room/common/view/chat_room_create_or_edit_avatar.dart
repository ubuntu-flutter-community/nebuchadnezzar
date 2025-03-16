import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../../common/view/build_context_x.dart';
import '../../../../common/view/common_widgets.dart';
import '../../../../common/view/snackbars.dart';
import '../../../../common/view/theme.dart';
import '../../../../common/view/ui_constants.dart';
import '../../../common/chat_model.dart';
import '../../../common/view/chat_avatar.dart';
import '../../input/draft_model.dart';

class ChatRoomCreateOrEditAvatar extends StatelessWidget with WatchItMixin {
  const ChatRoomCreateOrEditAvatar({
    super.key,
    required this.room,
    this.avatarDraftBytes,
  });

  final Room? room;
  final Uint8List? avatarDraftBytes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ava = watchStream(
      (ChatModel m) => m.getJoinedRoomAvatarStream(room),
      initialValue: room?.avatar,
    ).data;
    final foreGroundColor =
        context.colorScheme.isLight ? Colors.black : Colors.white;
    final attachingAvatar =
        watchPropertyValue((DraftModel m) => m.attachingAvatar);

    return Stack(
      key: ValueKey(ava?.toString()),
      children: [
        Padding(
          padding: const EdgeInsets.all(kSmallPadding),
          child: room != null
              ? ChatAvatar(
                  avatarUri: ava,
                  dimension: 80,
                  fallBackIconSize: 40,
                )
              : SizedBox.square(
                  dimension: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80 / 2),
                    child: ColoredBox(
                      color: getMonochromeBg(
                        theme: context.theme,
                        factor: 6,
                        darkFactor: 15,
                      ),
                      child: avatarDraftBytes == null
                          ? const Icon(
                              YaruIcons.user,
                              size: 40,
                            )
                          : Image.memory(
                              avatarDraftBytes!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              disabledBackgroundColor: context.colorScheme.surface,
              disabledForegroundColor: foreGroundColor,
            ),
            onPressed: attachingAvatar ||
                    room != null &&
                        room?.canChangeStateEvent(EventTypes.RoomAvatar) != true
                ? null
                : () => di<DraftModel>().setRoomAvatar(
                      room: room,
                      onFail: (error) =>
                          showSnackBar(context, content: Text(error)),
                      onWrongFileFormat: () => showSnackBar(
                        context,
                        content: Text(l10n.notAnImage),
                      ),
                    ),
            icon: attachingAvatar
                ? SizedBox.square(
                    dimension: 15,
                    child: Progress(
                      strokeWidth: 2,
                      color: foreGroundColor,
                    ),
                  )
                : Icon(
                    YaruIcons.pen,
                    color: contrastColor(context.colorScheme.primary),
                  ),
          ),
        ),
      ],
    );
  }
}
