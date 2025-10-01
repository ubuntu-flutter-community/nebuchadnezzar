import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:listen_it/listen_it.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/common_widgets.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../create_room_manager.dart';
import '../edit_room_service.dart';

class CreateOrEditRoomEncryptionTile extends StatelessWidget with WatchItMixin {
  const CreateOrEditRoomEncryptionTile({super.key, this.room});

  final Room? room;

  @override
  Widget build(BuildContext context) {
    final encrypted = room == null
        ? watchValue(
            (CreateRoomManager m) => m.draft.select((e) => e.enableEncryption),
          )
        : watchStream(
                (EditRoomService m) => m.getIsRoomEncryptedStream(room),
                initialValue: room!.encrypted,
                preserveState: false,
              ).data ??
              room!.encrypted;

    final canChangeEncryption = room == null
        ? true
        : room!.encrypted
        ? false
        : watchStream(
                (EditRoomService m) => m.getCanChangeEncryptionStream(room),
                initialValue: room!.canChangeStateEvent(EventTypes.Encryption),
                preserveState: false,
              ).data ??
              false;

    return YaruTile(
      leading: encrypted
          ? const Icon(YaruIcons.shield_filled)
          : const Icon(YaruIcons.shield),
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      trailing: CommonSwitch(
        value: encrypted,
        onChanged: canChangeEncryption
            ? (v) {
                if (room == null) {
                  di<CreateRoomManager>().updateDraft(enableEncryption: v);
                } else {
                  showFutureLoadingDialog(
                    context: context,
                    future: () =>
                        di<EditRoomService>().enableEncryptionForRoom(room!),
                  );
                }
              }
            : null,
      ),
      title: Text(context.l10n.encrypted),
    );
  }
}
