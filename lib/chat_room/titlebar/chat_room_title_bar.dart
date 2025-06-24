import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/space.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../common/view/chat_room_display_name.dart';
import '../common/view/chat_room_page.dart';
import 'chat_room_encryption_status_button.dart';
import 'chat_room_notification_button.dart';
import 'chat_room_pin_button.dart';
import 'side_bar_button.dart';

class ChatRoomTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatRoomTitleBar({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) => YaruWindowTitleBar(
    heroTag: '<Right hero tag>',
    border: BorderSide.none,
    backgroundColor: Colors.transparent,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: kSmallPadding,
      children: [
        if (room.isArchived)
          const Icon(YaruIcons.trash)
        else
          ChatRoomEncryptionStatusButton(
            key: ValueKey('${room.id}_${room.encrypted}'),
            room: room,
          ),
        Flexible(
          child: room.isArchived
              ? Text(
                  '${context.l10n.archive}: ${room.getLocalizedDisplayname()}',
                )
              : ChatRoomDisplayName(
                  key: ValueKey('${room.id}_displayname'),
                  room: room,
                ),
        ),
      ],
    ),
    leading: !Platform.isMacOS && !context.showSideBar
        ? const SideBarButton()
        : null,
    actions: space(
      widthGap: kSmallPadding,
      children: [
        if (!room.isArchived)
          ChatRoomPinButton(
            key: ValueKey('${room.id}_${room.isFavourite}'),
            room: room,
          ),
        if (!room.isArchived)
          ChatRoomNotificationButton(
            key: ValueKey('${room.id}_${room.pushRuleState.hashCode}'),
            room: room,
          ),
        IconButton(
          key: ValueKey('${room.id}_${room.isDirectChat}'),
          tooltip: context.l10n.chatDetails,
          onPressed: () => chatRoomScaffoldKey.currentState?.openEndDrawer(),
          icon: room.isDirectChat
              ? const Icon(YaruIcons.user)
              : const Icon(YaruIcons.information),
        ),
        if (!context.showSideBar && !kIsWeb && Platform.isMacOS)
          const SideBarButton(),
        const SizedBox(width: kSmallPadding),
      ].map((e) => Flexible(child: e)).toList(),
    ),
  );

  @override
  Size get preferredSize => const Size(0, kYaruTitleBarHeight);
}
