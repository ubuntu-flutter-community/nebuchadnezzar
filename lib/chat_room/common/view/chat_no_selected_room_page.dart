import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:yaru/yaru.dart';

import '../../../common/chat_manager.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../create_or_edit/edit_room_manager.dart';
import '../../titlebar/side_bar_button.dart';

class ChatNoSelectedRoomPage extends StatelessWidget with WatchItMixin {
  const ChatNoSelectedRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (EditRoomManager m) => m.knockOrJoinCommand,
      handler: (context, room, cancel) {
        if (room != null) {
          di<ChatManager>().setSelectedRoom(room);
          if (room.isSpace) {
            di<ChatManager>().setActiveSpace(room);
          }
        }
      },
    );

    registerHandler(
      select: (EditRoomManager m) => m.joinRoomCommand,
      handler: (context, room, cancel) {
        if (room != null) {
          di<ChatManager>().setSelectedRoom(room);
          if (room.isSpace) {
            di<ChatManager>().setActiveSpace(room);
          }
        }
      },
    );

    final loadingArchive = watchValue(
      (ChatManager m) => m.toggleArchiveCommand.isRunning,
    );

    final clearingArchive = watchValue(
      (EditRoomManager m) => m.forgetAllRoomsCommand.isRunning,
    );

    final progress = watchValue(
      (EditRoomManager m) => m.forgetAllRoomsCommand.progress,
    );

    return Scaffold(
      appBar: YaruWindowTitleBar(
        heroTag: '<Right hero tag>',
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
        title: const Text(''),
        leading: !kIsWeb && !Platform.isMacOS && !context.showSideBar
            ? const SideBarButton()
            : null,
        actions: [
          if (!context.showSideBar && !kIsWeb && Platform.isMacOS)
            const SideBarButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: kYaruTitleBarHeight),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: kBigPadding,
            children: [
              loadingArchive
                  ? LiquidCustomProgressIndicator(
                      backgroundColor:
                          context.theme.colorScheme.surfaceContainerHighest,
                      direction: Axis.vertical,
                      value: 0.5,
                      shapePath: _buildArchiveIconPath(),
                    )
                  : clearingArchive
                  ? LiquidCustomProgressIndicator(
                      backgroundColor:
                          context.theme.colorScheme.surfaceContainerHighest,
                      direction: Axis.vertical,
                      value: progress,
                      shapePath: _buildBoatPath(),
                    )
                  : Image.asset('assets/nebuchadnezzar.png', width: 100),
              Text(
                loadingArchive || clearingArchive
                    ? context.l10n.loadingPleaseWait
                    : 'Please select a chatroom from the side panel.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Path _buildBoatPath() {
    return Path()
      ..moveTo(15, 120)
      ..lineTo(0, 85)
      ..lineTo(50, 85)
      ..lineTo(50, 0)
      ..lineTo(105, 80)
      ..lineTo(60, 80)
      ..lineTo(60, 85)
      ..lineTo(120, 85)
      ..lineTo(105, 120)
      ..close();
  }

  Path _buildArchiveIconPath() {
    final path = Path()
      // 1. THE LID (Top Part)
      // Starting at the bottom-left of the lid
      ..moveTo(10, 35)
      ..lineTo(90, 35) // Bottom edge of lid
      ..lineTo(90, 20) // Right side
      ..quadraticBezierTo(90, 10, 80, 10) // Top-right corner
      ..lineTo(20, 10) // Top edge
      ..quadraticBezierTo(10, 10, 10, 20) // Top-left corner
      ..close()
      // 2. THE BODY (Bottom Part)
      ..moveTo(15, 40)
      ..lineTo(85, 40) // Top edge of body
      ..lineTo(85, 80) // Right side
      ..quadraticBezierTo(85, 90, 75, 90) // Bottom-right corner
      ..lineTo(25, 90) // Bottom edge
      ..quadraticBezierTo(15, 90, 15, 80) // Bottom-left corner
      ..close()
      // 3. THE HANDLE (Slot)
      // Adding a rounded rectangle cutout in the center
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(35, 50, 30, 10),
          const Radius.circular(5),
        ),
      )
      // Set the fill type to evenOdd so the handle appears as a "hole"
      ..fillType = PathFillType.evenOdd;

    return path;
  }
}
