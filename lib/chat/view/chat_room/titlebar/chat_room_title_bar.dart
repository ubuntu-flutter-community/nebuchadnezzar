import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../../common/view/build_context_x.dart';
import '../../../../common/view/common_widgets.dart';
import '../../../../common/view/space.dart';
import '../../../../common/view/ui_constants.dart';
import '../../../../l10n/l10n.dart';
import '../../../chat_model.dart';
import '../../side_bar_button.dart';
import '../chat_room_page.dart';
import 'chat_room_encryption_status_button.dart';
import 'chat_room_pin_button.dart';

class ChatRoomTitleBar extends StatelessWidget
    with WatchItMixin
    implements PreferredSizeWidget {
  const ChatRoomTitleBar({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return YaruWindowTitleBar(
      heroTag: '<Right hero tag>',
      border: BorderSide.none,
      backgroundColor: Colors.transparent,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: kSmallPadding,
        children: [
          ChatRoomEncryptionStatusButton(room: room),
          Flexible(
            child: Text(
              '${room.isArchived ? '(${l10n.archive}) ' : ''}${room.getLocalizedDisplayname()}',
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
          if (!room.isArchived) ChatRoomPinButton(room: room),
          IconButton(
            onPressed: () => chatRoomScaffoldKey.currentState?.openEndDrawer(),
            icon: const Icon(YaruIcons.information),
          ),
          if (!context.showSideBar && !kIsWeb && Platform.isMacOS)
            const SideBarButton(),
          const SizedBox(width: kSmallPadding),
        ].map((e) => Flexible(child: e)).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(0, kYaruTitleBarHeight);
}

class ChatRoomSearchDialog extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatRoomSearchDialog({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  State<ChatRoomSearchDialog> createState() => _ChatRoomSearchDialogState();
}

class _ChatRoomSearchDialogState extends State<ChatRoomSearchDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = watchFuture(
      (ChatModel m) => m.getEvents(widget.room),
      initialValue: <Event>[],
    ).data;

    final filteredEvents = events?.where(
      (e) => e.body.toLowerCase().contains(_controller.text.toLowerCase()),
    );

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      title: YaruDialogTitleBar(
        title:
            Text(context.l10n.searchIn(widget.room.getLocalizedDisplayname())),
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(kBigPadding),
          child: TextField(
            autocorrect: true,
            autofocus: true,
            controller: _controller,
            decoration: InputDecoration(
              label: Text(
                context.l10n.search,
              ),
            ),
          ),
        ),
        filteredEvents == null
            ? const Center(
                child: Progress(),
              )
            : Padding(
                padding: const EdgeInsets.all(kMediumPadding),
                child: SizedBox(
                  height: 500,
                  width: 500,
                  child: ListView.builder(
                    reverse: true,
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents.elementAt(index);
                      return ListTile(
                        dense: true,
                        title: Text(event.body),
                      );
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
