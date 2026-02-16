import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';

class ChatClearArchiveProgressBar extends StatelessWidget with WatchItMixin {
  const ChatClearArchiveProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = watchValue(
      (EditRoomManager m) => m.forgetAllRoomsCommand.progress,
    );
    return Stack(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 16),
            Text(
              '${context.l10n.delete}: ${(progress * 100).toStringAsFixed(0)}%',
            ),
          ],
        ),
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(seconds: 5),
            width: context.mediaQuerySize.width - 150,
            padding: const EdgeInsets.only(left: 150),
            child: LiquidLinearProgressIndicator(
              borderRadius: 20,
              value: progress,
              borderColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              borderWidth: 0,
              direction: Axis.horizontal,
              valueColor: AlwaysStoppedAnimation(
                context.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
