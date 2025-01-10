import 'dart:io';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/ui_constants.dart';
import '../../bootstrap/bootstrap_model.dart';
import '../../bootstrap/view/bootstrap_page.dart';
import '../../bootstrap/view/key_verification_dialog.dart';
import '../../chat_model.dart';
import '../chat_room/chat_room_page.dart';
import '../no_selected_room_page.dart';
import 'chat_master_panel.dart';

final GlobalKey<ScaffoldState> masterScaffoldKey = GlobalKey();

class ChatMasterDetailPage extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatMasterDetailPage({super.key});

  @override
  State<ChatMasterDetailPage> createState() => _ChatMasterDetailPageState();
}

class _ChatMasterDetailPageState extends State<ChatMasterDetailPage> {
  @override
  void initState() {
    super.initState();
    di<BootstrapModel>().isBootrapNeeded().then(
      (isNeeded) {
        if (isNeeded) {
          di<BootstrapModel>().startBootstrap(wipe: false).then((value) {
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => const SizedBox(
                  height: 500,
                  width: 400,
                  child: BootstrapPage(),
                ),
              );
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    registerStreamHandler(
      select: (ChatModel m) => m.onKeyVerificationRequest,
      handler: (context, newValue, cancel) {
        if (newValue.hasData) {
          showDialog(
            context: context,
            builder: (context) =>
                KeyVerificationDialog(request: newValue.data!),
          );
        }
      },
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
            const Expanded(child: NoSelectedRoomPage())
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
