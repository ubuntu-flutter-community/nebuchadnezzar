import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/common_widgets.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../create_or_edit_room_model.dart';
import 'chat_room_history_visibility_drop_down.dart';
import 'chat_room_join_rules_drop_down.dart';
import 'create_or_edit_room_canonical_alias_text_field.dart';
import 'create_or_edit_room_name_text_field.dart';
import 'create_or_edit_room_topic_text_field.dart';

class CreateOrEditRoomHeader extends StatelessWidget with WatchItMixin {
  const CreateOrEditRoomHeader({super.key, this.room, required this.isSpace});

  final Room? room;
  final bool isSpace;

  @override
  Widget build(BuildContext context) {
    final encrypted = room == null
        ? watchPropertyValue(
            (CreateOrEditRoomModel m) => m.enableEncryptionDraft,
          )
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

    final l10n = context.l10n;
    return YaruSection(
      headline: Text(l10n.group),
      child: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          spacing: kBigPadding,
          children: isSpace
              ? [
                  CreateOrEditRoomNameTextField(room: room, isSpace: isSpace),
                  if (room != null)
                    CreateOrEditRoomCanonicalAliasTextField(
                      room: room!,
                      isSpace: isSpace,
                    ),
                ]
              : [
                  CreateOrEditRoomNameTextField(room: room, isSpace: isSpace),
                  if (room != null) CreateOrEditRoomTopicTextField(room: room),
                  if (room != null)
                    CreateOrEditRoomCanonicalAliasTextField(
                      room: room!,
                      isSpace: isSpace,
                    ),
                  YaruTile(
                    leading: encrypted
                        ? const Icon(YaruIcons.shield_filled)
                        : const Icon(YaruIcons.shield),
                    padding: const EdgeInsets.symmetric(
                      horizontal: kMediumPadding,
                    ),
                    trailing: CommonSwitch(
                      value: encrypted,
                      onChanged: canChangeEncryption
                          ? (v) {
                              if (room == null) {
                                di<CreateOrEditRoomModel>()
                                    .setEnableEncryptionDraft(v);
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
                    title: Text(l10n.encrypted),
                  ),
                  ChatRoomHistoryVisibilityDropDown(room: room),
                  if (room != null)
                    ChatRoomJoinRulesDropDown(room: room!)
                  else ...const [
                    CreateRoomPresetSwitch(),
                    CreateRoomVisibilitySwitch(),
                  ],
                ],
        ),
      ),
    );
  }
}
