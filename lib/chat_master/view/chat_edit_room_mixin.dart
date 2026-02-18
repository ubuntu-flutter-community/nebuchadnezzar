import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../l10n/l10n.dart';
import 'chat_clear_archive_progress_bar.dart';

mixin ChatEditRoomMixin {
  void registerGlobalLeaveCommand() {
    registerHandler(
      select: (EditRoomManager m) => m.globalLeaveRoomCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.isRunning) {
          _showIndeterminateSpinnerSnackbar(
            context,
            '${context.l10n.leave} ${newValue.paramData?.getLocalizedDisplayname() ?? ''}',
          );
        } else if (newValue.hasError) {
          _showErrorSnackbar(
            context,
            '${context.l10n.oopsSomethingWentWrong} ${newValue.paramData?.getLocalizedDisplayname() ?? ''}: ${newValue.error}',
          );
        } else if (newValue.hasData && newValue.data != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                showCloseIcon: true,
                duration: const Duration(seconds: 3),
                content: Text(
                  'Left: ${newValue.data?.getLocalizedDisplayname() ?? ''}',
                ),
                action: SnackBarAction(
                  label: context.l10n.delete,
                  onPressed: () => di<EditRoomManager>().globalForgetRoomCommand
                      .run(newValue.data),
                ),
              ),
            );
        }
      },
    );
  }

  void registerGlobalForgetRoomCommand() {
    registerHandler(
      select: (EditRoomManager m) => m.globalForgetRoomCommand.results,
      handler: (context, newValue, cancel) {
        if (newValue.isRunning) {
          _showIndeterminateSpinnerSnackbar(
            context,
            'Deleting room ${newValue.paramData?.getLocalizedDisplayname() ?? ''}',
          );
        } else if (newValue.hasError) {
          _showErrorSnackbar(
            context,
            '${context.l10n.oopsSomethingWentWrong} ${newValue.paramData?.getLocalizedDisplayname() ?? ''}: ${newValue.error}',
          );
        } else if (newValue.hasData && newValue.data != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 3),
                content: Text(
                  'Deleted: ${newValue.data?.getLocalizedDisplayname() ?? ''}',
                ),
              ),
            );
        }
      },
    );
  }

  void registerForgetAllRoomsCommand() {
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
        } else if (newValue.hasError) {
          _showErrorSnackbar(
            context,
            '${context.l10n.oopsSomethingWentWrong}: ${newValue.error}',
          );
        }
      },
    );

    registerHandler(
      select: (EditRoomManager m) => m.forgetAllRoomsCommand.progress,
      handler: (context, newValue, cancel) {
        if (newValue == 1) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                content: Text('Clearing archive is complete'),
              ),
            );
        }
      },
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

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
