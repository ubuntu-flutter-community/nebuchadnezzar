import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/chat_avatar.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/theme.dart';
import '../../../common/view/ui_constants.dart';
import '../create_room_manager.dart';
import '../edit_room_service.dart';

class CreateOrEditRoomAvatar extends StatelessWidget with WatchItMixin {
  const CreateOrEditRoomAvatar({super.key, required this.room});

  final Room? room;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    final avatarDraftBytes = watchValue(
      (CreateRoomManager m) => m.draft.select((e) => e.avatar),
    )?.bytes;

    final isSettingAvatarOnRoom = watchValue(
      (EditRoomService m) => m.setRoomAvatarCommand.isRunning,
    );
    final isSettingAvatarOnCreate = watchValue(
      (CreateRoomManager m) => m.setRoomAvatarCommand.isRunning,
    );

    final isLoading = isSettingAvatarOnRoom || isSettingAvatarOnCreate;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(kSmallPadding),
          child: isLoading
              ? const _Plate(child: Progress())
              : room != null
              ? ChatAvatar(
                  avatarUri: watchStream(
                    (EditRoomService m) => m.getJoinedRoomAvatarStream(room),
                    initialValue: room?.avatar,
                  ).data,
                  dimension: 80,
                  fallBackIconSize: 40,
                )
              : _Plate(
                  child: avatarDraftBytes == null
                      ? const Icon(YaruIcons.user, size: 40)
                      : Image.memory(avatarDraftBytes, fit: BoxFit.cover),
                ),
        ),
        if (room?.canChangeStateEvent(EventTypes.RoomAvatar) == true ||
            room == null)
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
              onPressed: isLoading
                  ? null
                  : () => room == null
                        ? di<CreateRoomManager>().setRoomAvatarCommand.run(room)
                        : di<EditRoomService>().setRoomAvatarCommand.run(room!),
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

class _Plate extends StatelessWidget {
  const _Plate({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(80 / 2),
        child: ColoredBox(
          color: getMonochromeBg(
            theme: context.theme,
            factor: 6,
            darkFactor: 15,
          ),
          child: child,
        ),
      ),
    );
  }
}
