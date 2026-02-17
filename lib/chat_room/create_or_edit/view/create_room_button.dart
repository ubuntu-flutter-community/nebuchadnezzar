import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../../common/view/common_widgets.dart';
import '../../../l10n/l10n.dart';
import '../create_room_manager.dart';

class CreateRoomButton extends StatelessWidget with WatchItMixin {
  const CreateRoomButton({super.key, required this.shallBeSpace});

  final bool shallBeSpace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = watchValue(
      (CreateRoomManager m) => m.draft.select((e) => e.name),
    );

    final isCreating = watchValue(
      (CreateRoomManager m) => m.createRoomOrSpaceCommand.isRunning,
    );

    return ImportantButton(
      icon: isCreating
          ? const SizedBox(
              width: 16,
              height: 16,
              child: Progress(strokeWidth: 2),
            )
          : null,
      onPressed: name.trim().isEmpty || isCreating
          ? null
          : () => di<CreateRoomManager>().createRoomOrSpaceCommand.run(
              shallBeSpace,
            ),
      child: Text(shallBeSpace ? l10n.createNewSpace : l10n.createGroup),
    );
  }
}
