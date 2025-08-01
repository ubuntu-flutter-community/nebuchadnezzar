import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/chat_avatar.dart';
import '../../../common/view/theme.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../create_or_edit_room_model.dart';

class CreateOrEditRoomAvatar extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const CreateOrEditRoomAvatar({super.key, required this.room});

  final Room? room;

  @override
  State<CreateOrEditRoomAvatar> createState() => _CreateOrEditRoomAvatarState();
}

class _CreateOrEditRoomAvatarState extends State<CreateOrEditRoomAvatar> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    final avatarDraftBytes = watchValue(
      (CreateOrEditRoomModel m) => m.avatarDraft,
    )?.bytes;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(kSmallPadding),
          child: widget.room != null
              ? ChatAvatar(
                  avatarUri: watchStream(
                    (CreateOrEditRoomModel m) =>
                        m.getJoinedRoomAvatarStream(widget.room),
                    initialValue: widget.room?.avatar,
                  ).data,
                  dimension: 80,
                  fallBackIconSize: 40,
                )
              : SizedBox.square(
                  dimension: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80 / 2),
                    child: ColoredBox(
                      color: getMonochromeBg(
                        theme: theme,
                        factor: 6,
                        darkFactor: 15,
                      ),
                      child: avatarDraftBytes == null
                          ? const Icon(YaruIcons.user, size: 40)
                          : Image.memory(avatarDraftBytes, fit: BoxFit.cover),
                    ),
                  ),
                ),
        ),
        if (widget.room?.canChangeStateEvent(EventTypes.RoomAvatar) == true ||
            widget.room == null)
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                disabledBackgroundColor: colorScheme.surface.scale(
                  lightness: colorScheme.isLight ? -0.1 : 0.5,
                ),
              ),
              onPressed: () => showFutureLoadingDialog(
                context: context,
                future: () => di<CreateOrEditRoomModel>().setRoomAvatar(
                  room: widget.room,
                  wrongFormatString: context.l10n.notAnImage,
                ),
              ).then((_) => setState(() {})),
              icon: Icon(
                YaruIcons.pen,
                color: contrastColor(colorScheme.primary),
              ),
            ),
          ),
      ],
    );
  }
}
