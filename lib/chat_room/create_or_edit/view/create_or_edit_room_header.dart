import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import 'chat_room_history_visibility_drop_down.dart';
import 'chat_room_join_rules_drop_down.dart';
import 'create_or_edit_room_canonical_alias_text_field.dart';
import 'create_or_edit_room_encryption_tile.dart';
import 'create_or_edit_room_name_text_field.dart';
import 'create_or_edit_room_topic_text_field.dart';

class CreateOrEditRoomHeader extends StatelessWidget with WatchItMixin {
  const CreateOrEditRoomHeader({super.key, this.room, required this.isSpace});

  final Room? room;
  final bool isSpace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return YaruSection(
      headline: Text(isSpace ? l10n.space : l10n.group),
      child: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          spacing: kBigPadding,
          children: [
            CreateOrEditRoomNameTextField(room: room, isSpace: isSpace),
            if (room != null && !isSpace)
              CreateOrEditRoomTopicTextField(room: room),
            if (room != null)
              CreateOrEditRoomCanonicalAliasTextField(
                room: room!,
                isSpace: isSpace,
              ),
            if (!isSpace) ...[
              CreateOrEditRoomEncryptionTile(room: room),
              ChatRoomHistoryVisibilityDropDown(room: room),
              if (room != null)
                ChatRoomJoinRulesDropDown(room: room!)
              else ...const [
                CreateRoomPresetSwitch(),
                CreateRoomVisibilitySwitch(),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
