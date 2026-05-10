import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

mixin ChatEditRoomMixin {
  void registerGlobalLeaveOrForgetCommand() {
    registerHandler(
      select: (EditRoomManager m) => m.globalLeaveOrForgetRoomsCommand.results,
      handler: (context, results, cancel) {
        if (results.isRunning) {
          di<EditRoomManager>().toggleOrSetShowMarkRooms(show: false);
          context.toast(
            const _LeaveOrForgetRoomsProgress(),
            duration: const Duration(seconds: 3000),
          );
        } else if (results.hasError) {
        } else if (results.hasData && results.data != null) {
          context.toast(const LeaveOrForgetDoneSnackBarContent());
        }
      },
    );
  }
}

class LeaveOrForgetDoneSnackBarContent extends StatelessWidget
    with WatchItMixin {
  const LeaveOrForgetDoneSnackBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    final results = watchValue(
      (EditRoomManager m) => m.globalLeaveOrForgetRoomsCommand.results,
    );
    final paramData = results.paramData;
    final successful = results.data?.successful ?? [];
    final failed = results.data?.failed ?? [];
    final action = paramData?.action ?? LeaveOrForget.leave;
    final rooms = paramData?.rooms ?? [];
    final l10n = context.l10n;

    String text;
    if (failed.isEmpty) {
      text = action == LeaveOrForget.leave
          ? l10n.successfullyLeftXRooms(rooms.length)
          : l10n.successfullyForgotXRooms(rooms.length);
    } else {
      text = action == LeaveOrForget.leave
          ? l10n.successfullyLeftXButFailedYRooms(
              successful.length,
              rooms.length,
            )
          : l10n.successfullyForgotXButFailedYRooms(
              successful.length,
              rooms.length,
            );
    }

    return Text(text);
  }
}

class _LeaveOrForgetRoomsProgress extends StatelessWidget with WatchItMixin {
  const _LeaveOrForgetRoomsProgress();

  @override
  Widget build(BuildContext context) {
    final results = watchValue(
      (EditRoomManager m) => m.globalLeaveOrForgetRoomsCommand.results,
    );
    final paramData = results.paramData;
    final rooms = paramData?.rooms ?? [];
    final action = paramData?.action ?? LeaveOrForget.leave;
    final progress = watchValue(
      (EditRoomManager m) => m.globalLeaveOrForgetRoomsCommand.progress,
    );
    return Row(
      spacing: kMediumPadding,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, value: progress),
        ),
        Text(
          action == LeaveOrForget.leave
              ? context.l10n.leavingXofYRooms(
                  (progress * rooms.length).toInt(),
                  rooms.length,
                )
              : context.l10n.forgettingXofYRooms(
                  (progress * rooms.length).toInt(),
                  rooms.length,
                ),
        ),
      ],
    );
  }
}
