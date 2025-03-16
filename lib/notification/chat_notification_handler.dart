import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../l10n/l10n.dart';
import '../common/chat_model.dart';

void chatNotificationHandler(
  BuildContext context,
  AsyncSnapshot<Event?> newValue,
  void Function() cancel,
) {
  if (newValue.hasData) {
    final event = newValue.data!;
    final notification = LocalNotification(
      title: event.room.getLocalizedDisplayname(),
      body: event.body,
      actions: [
        LocalNotificationAction(text: context.l10n.openChat),
      ],
    );
    notification.onClick = () {
      di<ChatModel>().setSelectedRoom(event.room);
    };
    notification.onClickAction = (i) {
      di<ChatModel>().setSelectedRoom(event.room);
    };
    notification.show();
  }
}
