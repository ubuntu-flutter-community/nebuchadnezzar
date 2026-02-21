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

    final isArchiveActive = watchPropertyValue(
      (ChatManager m) => m.archiveActive,
    );

    final isArchiveEmpty =
        watchStream(
          (ChatManager m) => m.filteredRoomsStream,
          initialValue: di<ChatManager>().filteredRooms,
          preserveState: false,
        ).data?.isEmpty ??
        true;

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
                  : isArchiveActive
                  ? CustomPaint(
                      size: const Size(90, 90),
                      painter: _PathPainter(
                        path: _buildArchiveIconPath(),
                        color: context.theme.colorScheme.primary,
                      ),
                    )
                  : Image.asset(
                      'assets/nebuchadnezzar.png',
                      width: 90,
                      height: 90,
                    ),
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                  ),
                  child: Text(
                    loadingArchive
                        ? context.l10n.loadingArchivePleaseWait
                        : clearingArchive
                        ? context.l10n.clearingArchivePleaseWait
                        : isArchiveActive
                        ? isArchiveEmpty
                              ? context.l10n.archiveIsEmpty
                              : context.l10n.pleaseSelectAChatRoom
                        : context.l10n.pleaseSelectAChatRoom,
                    textAlign: TextAlign.center,
                  ),
                ),
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
      ..moveTo(10, 35)
      ..lineTo(90, 35)
      ..lineTo(90, 20)
      ..quadraticBezierTo(90, 10, 80, 10)
      ..lineTo(20, 10)
      ..quadraticBezierTo(10, 10, 10, 20)
      ..moveTo(15, 40)
      ..lineTo(85, 40)
      ..lineTo(85, 80)
      ..quadraticBezierTo(85, 90, 75, 90)
      ..lineTo(25, 90)
      ..quadraticBezierTo(15, 90, 15, 80)
      ..close()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(35, 50, 30, 10),
          const Radius.circular(5),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    return path;
  }
}

class _PathPainter extends CustomPainter {
  final Path path;
  final Color color;

  _PathPainter({required this.path, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final pathBounds = path.getBounds();
    final double scaleX = size.width / pathBounds.width;
    final double scaleY = size.height / pathBounds.height;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      ..scale(scale)
      ..translate(-pathBounds.center.dx, -pathBounds.center.dy);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas
      ..drawPath(path, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) {
    return oldDelegate.path != path || oldDelegate.color != color;
  }
}
