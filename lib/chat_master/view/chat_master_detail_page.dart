import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../chat_room/common/view/chat_room_loading_page.dart';
import '../../chat_room/input/draft_manager.dart';
import '../../common/chat_manager.dart';
import '../../common/platforms.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../encryption/encryption_manager.dart';
import '../../encryption/view/chat_global_handlers.dart';
import '../../encryption/view/key_verification_dialog.dart';
import '../../notification/chat_notification_handler.dart';
import '../../player/view/player_view.dart';
import 'chat_edit_room_mixin.dart';
import 'chat_master_panel.dart';

final GlobalKey<ScaffoldState> masterScaffoldKey = GlobalKey();

class ChatMasterDetailPage extends StatelessWidget
    with WatchItMixin, ChatEditRoomMixin, ChatGlobalHandlerMixin {
  const ChatMasterDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    registerGlobalChatHandlers();

    registerGlobalLeaveForgetCommands();

    registerHandler(
      select: (DraftManager m) => m.sendCommand.errors,
      handler: (context, newValue, cancel) {
        if (newValue?.error != null) {
          showErrorSnackBar(context, newValue!.error.toString());
        }
      },
    );

    registerStreamHandler(
      select: (EncryptionManager m) => m.onKeyVerificationRequest,
      handler: (context, newValue, cancel) {
        if (newValue.hasData) {
          KeyVerificationDialog(
            request: newValue.data!,
            verifyOther: true,
          ).show(context);
        }
      },
    );

    registerStreamHandler(
      select: (ChatManager m) => m.notificationStream,
      handler: chatNotificationHandler,
    );

    return Scaffold(
      key: masterScaffoldKey,
      drawer: !Platforms.isMacOS
          ? const Drawer(child: ChatMasterSidePanel())
          : null,
      endDrawer: Platforms.isMacOS
          ? const Drawer(child: ChatMasterSidePanel())
          : null,
      body: Row(
        children: [
          if (context.showSideBar) ...[
            const SizedBox(width: kSideBarWith, child: ChatMasterSidePanel()),
          ],
          if (context.showSideBar)
            const VerticalDivider(width: 0, thickness: 0),
          const Expanded(child: ChatRoomLoadingPage()),
        ],
      ),
      bottomNavigationBar: const PlayerView(),
    );
  }
}
