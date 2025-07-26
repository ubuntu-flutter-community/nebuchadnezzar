import 'package:flutter/material.dart' hide Visibility;
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/ui_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n.dart';
import '../create_or_edit_room_model.dart';

class ChatRoomJoinRulesDropDown extends StatelessWidget with WatchItMixin {
  const ChatRoomJoinRulesDropDown({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final canChangeJoinRules =
        watchStream(
          (CreateOrEditRoomModel m) => m.getCanChangeJoinRulesStream(room),
          preserveState: false,
          initialValue: room.canChangeJoinRules,
        ).data ??
        room.canChangeJoinRules;

    final joinRules =
        watchStream(
          (CreateOrEditRoomModel m) => m.getJoinedRoomJoinRulesStream(room),
          preserveState: false,
          initialValue: room.joinRules,
        ).data ??
        JoinRules.private;

    return YaruTile(
      leading: const Icon(YaruIcons.private_mask),
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      // TODO: localize
      title: const Text('Join Rules'),
      enabled: canChangeJoinRules,
      trailing: YaruPopupMenuButton<JoinRules>(
        enabled: canChangeJoinRules,
        initialValue: joinRules,
        onSelected: canChangeJoinRules
            ? (v) => showFutureLoadingDialog(
                context: context,
                future: () => di<CreateOrEditRoomModel>().setJoinRulesForRoom(
                  room: room,
                  value: v,
                ),
              )
            : null,
        itemBuilder: (context) => JoinRules.values
            .map((e) => PopupMenuItem(value: e, child: Text(e.localize(l10n))))
            .toList(),
        child: Text(joinRules.localize(l10n)),
      ),
    );
  }
}

class CreateRoomVisibilitySwitch extends StatelessWidget with WatchItMixin {
  const CreateRoomVisibilitySwitch({super.key});

  @override
  Widget build(BuildContext context) => SwitchListTile(
    title: Text(context.l10n.groupCanBeFoundViaSearch),
    value:
        watchPropertyValue((CreateOrEditRoomModel m) => m.visibilityDraft) ==
        Visibility.public,
    onChanged: (value) => di<CreateOrEditRoomModel>().setVisibilityDraft(
      value ? Visibility.public : Visibility.private,
    ),
  );
}

// Create CreateRoomPreset switch
class CreateRoomPresetSwitch extends StatelessWidget with WatchItMixin {
  const CreateRoomPresetSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final preset = watchPropertyValue(
      (CreateOrEditRoomModel m) => m.createRoomPresetDraft,
    );

    return SwitchListTile(
      title: Text(l10n.groupIsPublic),
      value: preset == CreateRoomPreset.publicChat,
      onChanged: (value) =>
          di<CreateOrEditRoomModel>().setCreateRoomPresetDraft(
            value ? CreateRoomPreset.publicChat : CreateRoomPreset.privateChat,
          ),
    );
  }
}

extension JoinRulesX on JoinRules {
  String localize(AppLocalizations l10n) => switch (this) {
    JoinRules.public => l10n.anyoneCanJoin,
    JoinRules.knock => l10n.knock,
    JoinRules.invite => l10n.guestsCanJoin,
    JoinRules.private => l10n.noOneCanJoin,
    JoinRules.restricted => l10n.restricted,
    JoinRules.knockRestricted => l10n.knockRestricted,
  };

  JoinRules fromString(String value) => switch (value) {
    'public' => JoinRules.public,
    'knock' => JoinRules.knock,
    'invite' => JoinRules.invite,
    'private' => JoinRules.private,
    'restricted' => JoinRules.restricted,
    'knock_restricted' => JoinRules.knockRestricted,
    _ => JoinRules.private, // Default case
  };
}
