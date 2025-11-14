import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:window_manager/window_manager.dart';

import '../l10n/l10n.dart';
import '../common/chat_manager.dart';

Future<void> chatNotificationHandler(
  BuildContext context,
  AsyncSnapshot<Event?> newValue,
  void Function() cancel,
) async {
  final focused = await di<WindowManager>().isFocused();
  final selectedRoom = di<ChatManager>().selectedRoom;
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
      di<ChatManager>().setSelectedRoom(event.room);
    };
    notification.onClickAction = (i) {
      di<ChatManager>().setSelectedRoom(event.room);
      di<WindowManager>().focus();
    };
    notification.show();
  }
}
