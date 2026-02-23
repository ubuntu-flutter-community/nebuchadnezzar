import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/chat_manager.dart';
import '../../../common/platforms.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../create_or_edit/create_room_manager.dart';
import '../../create_or_edit/edit_room_manager.dart';
import '../../titlebar/side_bar_button.dart';
import 'chat_join_mixin.dart';
import 'chat_no_selected_room_page.dart';
import 'chat_room_page.dart';

class ChatRoomLoadingPage extends StatelessWidget
    with WatchItMixin, ChatJoinMixin {
  const ChatRoomLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    registerJoinHandlers(context);

    final selectedRoom = watchPropertyValue((ChatManager m) => m.selectedRoom);
    final isArchivedRoom = watchPropertyValue(
      (ChatManager m) => m.selectedRoom?.isArchived == true,
    );

    final joiningDirectChat = watchValue(
      (CreateRoomManager m) => m.createOrGetDirectChatCommand.isRunning,
    );

    final knockIngOrJoining = watchValue(
      (EditRoomManager m) => m.knockOrJoinCommand.isRunning,
    );

    final joining = watchValue(
      (EditRoomManager m) => m.joinRoomCommand.isRunning,
    );

    if (joiningDirectChat || knockIngOrJoining || joining) {
      return Scaffold(
        appBar: YaruWindowTitleBar(
          heroTag: '<Right hero tag>',
          border: BorderSide.none,
          backgroundColor: Colors.transparent,
          title: const Text(''),
          leading:
              !Platforms.isWeb && !Platforms.isMacOS && !context.showSideBar
              ? const SideBarButton()
              : null,
          actions: [
            if (!context.showSideBar && !Platforms.isWeb && Platforms.isMacOS)
              const SideBarButton(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: kYaruTitleBarHeight),
          child: Center(
            child: Column(
              mainAxisSize: .min,
              spacing: kBigPadding,
              children: [
                const Progress(),
                Text(context.l10n.joiningRoomPleaseWait),
              ],
            ),
          ),
        ),
      );
    }

    if (selectedRoom == null) {
      return const ChatNoSelectedRoomPage();
    } else {
      return ChatRoomPage(
        key: ValueKey('${selectedRoom.id} $isArchivedRoom'),
        room: selectedRoom,
      );
    }
  }
}
