import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:listen_it/listen_it.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/ui_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n.dart';
import '../create_room_manager.dart';
import '../edit_room_service.dart';

class ChatRoomHistoryVisibilityDropDown extends StatelessWidget
    with WatchItMixin {
  const ChatRoomHistoryVisibilityDropDown({super.key, required this.room});

  final Room? room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final historyVisibilityDraft = watchValue(
      (CreateRoomManager m) => m.draft.select((e) => e.historyVisibility),
    );
    final vis = room == null
        ? historyVisibilityDraft
        : watchStream(
                (EditRoomService m) =>
                    m.getJoinedRoomHistoryVisibilityStream(room!),
                initialValue: room!.historyVisibility,
                preserveState: false,
              ).data ??
              room!.historyVisibility;

    final canChangeHistoryVisibility = room == null
        ? true
        : watchStream(
                (EditRoomService m) =>
                    m.getCanChangeHistoryVisibilityStream(room!),
                initialValue: room!.canChangeHistoryVisibility,
                preserveState: false,
              ).data ??
              false;

    return YaruTile(
      leading: const Icon(YaruIcons.private_mask),
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      title: Text(l10n.visibilityOfTheChatHistory),
      trailing: YaruPopupMenuButton<HistoryVisibility>(
        initialValue: vis,
        enabled: canChangeHistoryVisibility,
        onSelected: room == null
            ? (v) => di<CreateRoomManager>().updateDraft(historyVisibility: v)
            : canChangeHistoryVisibility
            ? (v) => showFutureLoadingDialog(
                context: context,
                future: () => di<EditRoomService>().setHistoryVisibilityForRoom(
                  room: room!,
                  value: v,
                ),
              )
            : null,
        itemBuilder: (context) => HistoryVisibility.values
            .map((e) => PopupMenuItem(value: e, child: Text(e.localize(l10n))))
            .toList(),
        child: Text(
          room == null
              ? historyVisibilityDraft.localize(l10n)
              : room!.historyVisibility?.localize(l10n) ?? '',
        ),
      ),
    );
  }
}

extension on HistoryVisibility {
  String localize(AppLocalizations l10n) {
    return switch (this) {
      HistoryVisibility.worldReadable => l10n.visibleForEveryone,
      HistoryVisibility.shared => l10n.share,
      HistoryVisibility.invited => l10n.fromTheInvitation,
      HistoryVisibility.joined => l10n.fromJoining,
    };
  }
}
