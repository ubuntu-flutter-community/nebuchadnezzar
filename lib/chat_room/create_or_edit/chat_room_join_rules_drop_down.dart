import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import 'create_or_edit_room_model.dart';

class ChatRoomJoinRulesDropDown extends StatelessWidget with WatchItMixin {
  const ChatRoomJoinRulesDropDown({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final canChangeJoinRules =
        watchStream(
          (ChatModel m) => m
              .getJoinedRoomUpdate(room.id)
              .map((_) => room.canChangeJoinRules),
          preserveState: false,
          initialValue: room.canChangeJoinRules,
        ).data ??
        false;

    final joinRules =
        watchStream(
          (ChatModel m) =>
              m.getJoinedRoomUpdate(room.id).map((_) => room.joinRules),
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
        onSelected: canChangeJoinRules
            ? (v) => showFutureLoadingDialog(
                context: context,
                onError: (e) {
                  showErrorSnackBar(context, e);
                  return e;
                },
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

class ChatCreateRoomJoinRulesDropDown extends StatelessWidget
    with WatchItMixin {
  const ChatCreateRoomJoinRulesDropDown({
    super.key,
    required this.joinRules,
    required this.onSelected,
  });

  final JoinRules joinRules;
  final void Function(JoinRules joinRules) onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return YaruTile(
      leading: const Icon(YaruIcons.private_mask),
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      // TODO: localize
      title: const Text('Join Rules'),
      trailing: YaruPopupMenuButton<JoinRules>(
        onSelected: onSelected,
        itemBuilder: (context) => JoinRules.values
            .map((e) => PopupMenuItem(value: e, child: Text(e.localize(l10n))))
            .toList(),
        child: Text(joinRules.localize(l10n)),
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
