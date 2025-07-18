import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../chat_room/titlebar/chat_room_pin_button.dart';

class ChatMasterTileMenu extends StatefulWidget {
  const ChatMasterTileMenu({
    super.key,
    required this.child,
    required this.room,
  });

  final Widget child;
  final Room room;

  @override
  State<ChatMasterTileMenu> createState() => _ChatMasterTileMenuState();
}

class _ChatMasterTileMenuState extends State<ChatMasterTileMenu> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: () =>
          _controller.isOpen ? _controller.close() : _controller.open(),
      child: MenuAnchor(
        alignmentOffset: const Offset(20, -80),
        controller: _controller,
        consumeOutsideTap: true,
        menuChildren: [ChatRoomPinButton.menuEntry(room: widget.room)],
        child: widget.child,
      ),
    );
  }
}
