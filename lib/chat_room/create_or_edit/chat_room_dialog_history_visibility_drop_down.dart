import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';
import '../../common/chat_model.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';

class ChatRoomDialogHistoryVisibilityDropDown extends StatelessWidget
    with WatchItMixin {
  const ChatRoomDialogHistoryVisibilityDropDown({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vis =
        watchStream(
          (ChatModel m) =>
              m.getJoinedRoomUpdate(room.id).map((_) => room.historyVisibility),
          initialValue: room.historyVisibility,
          preserveState: false,
        ).data ??
        room.historyVisibility;

    final canChangeHistoryVisibility =
        watchStream(
          (ChatModel m) => m
              .getJoinedRoomUpdate(room.id)
              .map((_) => room.canChangeHistoryVisibility),
          initialValue: room.canChangeHistoryVisibility,
          preserveState: false,
        ).data ??
        false;

    return YaruTile(
      leading: const Icon(YaruIcons.private_mask),
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      title: Text(l10n.visibilityOfTheChatHistory),
      trailing: YaruPopupMenuButton<HistoryVisibility>(
        initialValue: vis,
        onSelected: canChangeHistoryVisibility
            ? (v) => room.setHistoryVisibility(v)
            : null,
        itemBuilder: (context) => HistoryVisibility.values
            .map((e) => PopupMenuItem(value: e, child: Text(e.localize(l10n))))
            .toList(),
        child: Text(room.historyVisibility?.localize(l10n) ?? ''),
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
