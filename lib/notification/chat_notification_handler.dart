import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:window_manager/window_manager.dart';

import '../l10n/l10n.dart';
import '../common/chat_model.dart';

Future<void> chatNotificationHandler(
  BuildContext context,
  AsyncSnapshot<Event?> newValue,
  void Function() cancel,
) async {
  final focused = await windowManager.isFocused();
  final selectedRoom = di<ChatModel>().selectedRoom;
  if (newValue.hasData && !focused && selectedRoom == null ||
      selectedRoom?.id != newValue.data?.room.id) {
    final event = newValue.data!;
    final notification = LocalNotification(
      title: event.room.getLocalizedDisplayname(),
      body: event.body,
      actions: [
        LocalNotificationAction(
          text: context.mounted ? context.l10n.openChat : 'Open Chat',
        ),
      ],
    );
    notification.onClick = () {
      di<ChatModel>().setSelectedRoom(event.room);
    };
    notification.onClickAction = (i) {
      di<ChatModel>().setSelectedRoom(event.room);
      windowManager.focus();
    };
    notification.show();
  }
}
