import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/common_widgets.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../create_or_edit_room_model.dart';

class CreateOrEditRoomEncryptionTile extends StatelessWidget with WatchItMixin {
  const CreateOrEditRoomEncryptionTile({super.key, this.room});

  final Room? room;

  @override
  Widget build(BuildContext context) {
    final encrypted = room == null
        ? watchValue((CreateOrEditRoomModel m) => m.enableEncryptionDraft)
        : watchStream(
                (CreateOrEditRoomModel m) => m.getIsRoomEncryptedStream(room),
                initialValue: room!.encrypted,
                preserveState: false,
              ).data ??
              room!.encrypted;

    final canChangeEncryption = room == null
        ? true
        : room!.encrypted
        ? false
        : watchStream(
                (CreateOrEditRoomModel m) =>
                    m.getCanChangeEncryptionStream(room),
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
                  di<CreateOrEditRoomModel>().enableEncryptionDraft.value = v;
                } else {
                  showFutureLoadingDialog(
                    context: context,
                    future: () => di<CreateOrEditRoomModel>()
                        .enableEncryptionForRoom(room!),
                  );
                }
              }
            : null,
      ),
      title: Text(context.l10n.encrypted),
    );
  }
}
