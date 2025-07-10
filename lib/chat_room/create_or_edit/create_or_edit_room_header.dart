import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import 'chat_room_history_visibility_drop_down.dart';
import 'chat_room_join_rules_drop_down.dart';
import 'create_or_edit_room_model.dart';
import 'create_or_edit_room_name_text_field.dart';
import 'create_or_edit_room_topic_text_field.dart';

class CreateOrEditRoomHeader extends StatelessWidget with WatchItMixin {
  const CreateOrEditRoomHeader({super.key, this.room});

  final Room? room;

  @override
  Widget build(BuildContext context) {
    final isSpace = watchPropertyValue((CreateOrEditRoomModel m) => m.isSpace);

    final encrypted = room == null
        ? watchPropertyValue((CreateOrEditRoomModel m) => m.enableEncryption)
        : room!.encrypted;

    final canChangeEncryption = room == null
        ? true
        : room!.encrypted
        ? false
        : watchStream(
                (ChatModel m) => m
                    .getJoinedRoomUpdate(room?.id)
                    .map(
                      (_) => room!.canChangeStateEvent(EventTypes.Encryption),
                    ),
                initialValue: room!.canChangeStateEvent(EventTypes.Encryption),
                preserveState: false,
              ).data ??
              false;

    final l10n = context.l10n;
    return YaruSection(
      headline: Text(l10n.group),
      child: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          spacing: kBigPadding,
          children: [
            CreateOrEditRoomNameTextField(room: room),
            CreateOrEditRoomTopicTextField(room: room),
            if (!isSpace)
              YaruTile(
                leading: encrypted
                    ? const Icon(YaruIcons.shield_filled)
                    : const Icon(YaruIcons.shield),
                padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
                trailing: CommonSwitch(
                  value: encrypted,
                  onChanged: canChangeEncryption
                      ? (v) {
                          if (room == null) {
                            di<CreateOrEditRoomModel>().setEnableEncryption(v);
                          } else {
                            showFutureLoadingDialog(
                              context: context,
                              future: () => di<CreateOrEditRoomModel>()
                                  .enableEncryptionForRoom(room!),
                              onError: (e) {
                                showErrorSnackBar(context, e);
                                return e;
                              },
                            );
                          }
                        }
                      : null,
                ),
                title: Text(l10n.encrypted),
              ),
            if (room != null)
              ChatRoomHistoryVisibilityDropDown(room: room!)
            else if (!isSpace)
              ChatCreateRoomHistoryVisibilityDropDown(
                initialValue: watchPropertyValue(
                  (CreateOrEditRoomModel m) => m.historyVisibility,
                ),
                onSelected: di<CreateOrEditRoomModel>().setHistoryVisibility,
              ),
            if (room != null)
              ChatRoomJoinRulesDropDown(room: room!)
            else
              ChatCreateRoomJoinRulesDropDown(
                joinRules: watchPropertyValue(
                  (CreateOrEditRoomModel m) => m.joinRules,
                ),
                onSelected: di<CreateOrEditRoomModel>().setJoinRules,
              ),
          ],
        ),
      ),
    );
  }
}
