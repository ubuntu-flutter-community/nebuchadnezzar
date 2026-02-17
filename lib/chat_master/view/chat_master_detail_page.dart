import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../authentication/authentication_service.dart';
import '../../authentication/view/chat_login_page.dart';
import '../../authentication/view/uia_request_handler.dart';
import '../../chat_room/common/view/chat_no_selected_room_page.dart';
import '../../chat_room/common/view/chat_room_page.dart';
import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/chat_manager.dart';
import '../../common/platforms.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../encryption/encryption_manager.dart';
import '../../encryption/view/key_verification_dialog.dart';
import '../../l10n/l10n.dart';
import '../../notification/chat_notification_handler.dart';
import '../../player/view/player_view.dart';
import 'chat_clear_archive_progress_bar.dart';
import 'chat_master_panel.dart';

final GlobalKey<ScaffoldState> masterScaffoldKey = GlobalKey();

class ChatMasterDetailPage extends StatelessWidget with WatchItMixin {
  const ChatMasterDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (EditRoomManager m) => m.forgetAllRoomsCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.isRunning) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3000),
                content: ChatClearArchiveProgressBar(),
              ),
            );
        } else if (newValue.hasData) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(content: Text('Deleted all rooms')));
        } else if (newValue.hasError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  '${context.l10n.oopsSomethingWentWrong}: ${newValue.error}',
                ),
              ),
            );
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
            }
          });
        }
      },
    );

    registerHandler(
      select: (EditRoomManager m) => m.globalLeaveRoomCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.isRunning) {
          _showIndeterminateSpinnerSnackbar(
            context,
            '${context.l10n.leave} ${newValue.data?.getLocalizedDisplayname() ?? ''}',
          );
        } else if (newValue.hasError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  '${context.l10n.oopsSomethingWentWrong} ${newValue.data?.getLocalizedDisplayname() ?? ''}: ${newValue.error}',
                ),
              ),
            );
        } else if (newValue.hasData) {
          ScaffoldMessenger.of(context).clearSnackBars();
          if (newValue.data != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Left: ${newValue.data?.getLocalizedDisplayname() ?? ''}',
                ),
                action: SnackBarAction(
                  label: context.l10n.delete,
                  onPressed: () => di<EditRoomManager>().globalForgetRoomCommand
                      .run(newValue.data!),
                ),
              ),
            );
          }
        } else {
          Future.delayed(const Duration(seconds: 4), () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
            }
          });
        }
      },
    );

    registerHandler(
      select: (EditRoomManager m) => m.globalLeaveRoomCommand,
      handler: (context, newValue, cancel) {},
    );

    registerHandler(
      select: (EditRoomManager m) => m.globalForgetRoomCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.isRunning) {
          _showIndeterminateSpinnerSnackbar(
            context,
            '${context.l10n.delete} ${newValue.data?.getLocalizedDisplayname() ?? ''}',
          );
        } else if (newValue.hasData && newValue.data != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  'Deleted: ${newValue.data?.getLocalizedDisplayname() ?? ''}',
                ),
              ),
            );
        } else if (newValue.hasError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  '${context.l10n.oopsSomethingWentWrong} ${newValue.data?.getLocalizedDisplayname() ?? ''}: ${newValue.error}',
                ),
              ),
            );
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
      select: (AuthenticationService m) => m.onUiaRequestStream,
      handler: (context, newValue, cancel) async {
        if (newValue.hasData) {
          await uiaRequestHandler(
            uiaRequest: newValue.data!,
            context: context,
            rootNavigator: true,
          );
        }
      },
    );

    registerStreamHandler(
      select: (AuthenticationService m) => m.loginStateStream,
      handler: (context, newValue, cancel) {
        if (newValue.hasData && newValue.data != LoginState.loggedIn) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const ChatLoginPage()),
            (route) => false,
          );
        }
      },
    );

    registerStreamHandler(
      select: (ChatManager m) => m.notificationStream,
      handler: chatNotificationHandler,
    );

    // TODO: #6
    // registerStreamHandler(
    //   select: (Client m) => m.onCallEvents.stream,
    //   handler: callHandler,
    // );

    final selectedRoom = watchPropertyValue((ChatManager m) => m.selectedRoom);
    final isArchivedRoom = watchPropertyValue(
      (ChatManager m) => m.selectedRoom?.isArchived == true,
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
          if (selectedRoom == null)
            const Expanded(child: ChatNoSelectedRoomPage())
          else
            Expanded(
              child: ChatRoomPage(
                key: ValueKey('${selectedRoom.id} $isArchivedRoom'),
                room: selectedRoom,
              ),
            ),
        ],
      ),
      bottomNavigationBar: const PlayerView(),
    );
  }

  void _showIndeterminateSpinnerSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 100),
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 16),
              Text(text),
            ],
          ),
        ),
      );
  }
}
