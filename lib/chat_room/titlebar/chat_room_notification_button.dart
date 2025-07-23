import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/chat_model.dart';
import '../../common/push_rule_state_x.dart';
import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';
import '../create_or_edit/create_or_edit_room_model.dart';

class ChatRoomNotificationButton extends StatelessWidget with WatchItMixin {
  const ChatRoomNotificationButton({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final pushRuleState =
        watchStream(
          (ChatModel m) => m.syncStream.map((_) => room.pushRuleState),
          initialValue: room.pushRuleState,
        ).data ??
        room.pushRuleState;

    return PopupMenuButton(
      tooltip: context.l10n.notifications,
      padding: EdgeInsets.zero,
      initialValue: pushRuleState,
      onSelected: (v) => showFutureLoadingDialog(
        context: context,
        future: () =>
            di<CreateOrEditRoomModel>().setPushRuleState(room, value: v),
      ),
      itemBuilder: (context) => PushRuleState.values
          .map(
            (e) => PopupMenuItem<PushRuleState>(
              value: e,
              child: ListTile(
                leading: e.getIcon(context.colorScheme),
                title: Text(e.localize(context.l10n)),
              ),
            ),
          )
          .toList(),
      icon: pushRuleState.getIcon(context.colorScheme),
    );
  }
}

class ChatRoomNotificationsDialog extends StatelessWidget with WatchItMixin {
  const ChatRoomNotificationsDialog({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final pushRuleState =
        watchStream(
          (ChatModel m) => m.syncStream.map((_) => room.pushRuleState),
          initialValue: room.pushRuleState,
        ).data ??
        room.pushRuleState;

    return SimpleDialog(
      children: PushRuleState.values
          .map(
            (e) => ListTile(
              shape: const RoundedRectangleBorder(),
              selected: e == pushRuleState,
              selectedColor: context.colorScheme.primary,
              leading: e.getIcon(context.colorScheme),
              title: Text(e.localize(context.l10n)),
              onTap: () {
                di<CreateOrEditRoomModel>().setPushRuleState(room, value: e);
                Navigator.of(context).pop();
              },
            ),
          )
          .toList(),
    );
  }
}
