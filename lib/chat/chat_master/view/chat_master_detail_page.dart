import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/ui_constants.dart';
import '../../authentication/authentication_model.dart';
import '../../authentication/chat_login_page.dart';
import '../../authentication/uia_request_handler.dart';
import '../../bootstrap/view/key_verification_dialog.dart';
import '../../chat_room/common/view/chat_no_selected_room_page.dart';
import '../../chat_room/common/view/chat_room_page.dart';
import '../../common/chat_model.dart';
import '../../notification/chat_notification_handler.dart';
import 'chat_master_panel.dart';

final GlobalKey<ScaffoldState> masterScaffoldKey = GlobalKey();

class ChatMasterDetailPage extends StatelessWidget with WatchItMixin {
  const ChatMasterDetailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    registerStreamHandler(
      select: (AuthenticationModel m) => m.onKeyVerificationRequest,
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
      select: (AuthenticationModel m) => m.onUiaRequestStream,
      handler: (context, newValue, cancel) {
        if (newValue.hasData) {
          uiaRequestHandler(uiaRequest: newValue.data!, context: context);
        }
      },
    );

    registerStreamHandler(
      select: (AuthenticationModel m) => m.loginStateStream,
      handler: (context, newValue, cancel) {
        if (newValue.hasData && newValue.data != LoginState.loggedIn) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const ChatLoginPage(),
            ),
            (route) => false,
          );
        }
      },
    );

    registerStreamHandler(
      select: (ChatModel m) => m.notificationStream,
      handler: chatNotificationHandler,
    );

    final selectedRoom = watchPropertyValue((ChatModel m) => m.selectedRoom);
    final isArchivedRoom =
        watchPropertyValue((ChatModel m) => m.selectedRoom?.isArchived == true);
    final processingJoinOrLeave =
        watchPropertyValue((ChatModel m) => m.processingJoinOrLeave);
    final loadingArchive =
        watchPropertyValue((ChatModel m) => m.loadingArchive);

    return Scaffold(
      key: masterScaffoldKey,
      drawer:
          !Platform.isMacOS ? const Drawer(child: ChatMasterSidePanel()) : null,
      endDrawer:
          Platform.isMacOS ? const Drawer(child: ChatMasterSidePanel()) : null,
      body: Row(
        children: [
          if (context.showSideBar)
            const SizedBox(width: kSideBarWith, child: ChatMasterSidePanel()),
          if (context.showSideBar)
            const VerticalDivider(
              width: 0,
              thickness: 0,
            ),
          if (processingJoinOrLeave || loadingArchive)
            const Expanded(
              child: Center(
                child: Progress(),
              ),
            )
          else if (selectedRoom == null)
            const Expanded(child: ChatNoSelectedRoomPage())
          else
            Expanded(
              child: ChatRoomPage(
                key: ValueKey(
                  '${selectedRoom.id} $isArchivedRoom',
                ),
                room: selectedRoom,
              ),
            ),
        ],
      ),
    );
  }
}
