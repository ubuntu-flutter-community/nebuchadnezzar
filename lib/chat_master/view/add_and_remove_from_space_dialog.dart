import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../chat_room/create_or_edit/create_or_edit_room_model.dart';
import '../../common/chat_model.dart';
import '../../common/room_x.dart';
import '../../common/view/confirm.dart';
import '../../l10n/l10n.dart';

class RemoveFromSpaceDialog extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const RemoveFromSpaceDialog({super.key, required this.room});

  final Room room;

  @override
  State<RemoveFromSpaceDialog> createState() => _RemoveFromSpaceDialogState();
}

class _RemoveFromSpaceDialogState extends State<RemoveFromSpaceDialog> {
  Room? _selectedSpace;

  @override
  void initState() {
    super.initState();
    _selectedSpace = di<ChatModel>().spaces.firstWhereOrNull(
      (space) =>
          space.spaceChildren.map((c) => c.roomId).contains(widget.room.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spaces = watchPropertyValue((ChatModel m) => m.spaces);

    return ConfirmationDialog(
      title: Text(context.l10n.removeFromSpace),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: spaces
            .where(
              (e) =>
                  e.spaceChildren.map((c) => c.roomId).contains(widget.room.id),
            )
            .toList()
            .map(
              (space) => RadioGroup(
                groupValue: _selectedSpace,
                onChanged: (value) => setState(() => _selectedSpace = value),
                child: RadioListTile<Room>(
                  title: Text(space.getLocalizedDisplayname()),
                  value: space,
                ),
              ),
            )
            .toList(),
      ),
      confirmEnabled: _selectedSpace != null,
      onConfirm: () => showFutureLoadingDialog(
        context: context,
        future: () => di<CreateOrEditRoomModel>().removeFromSpace(
          widget.room,
          _selectedSpace!,
        ),
      ),
    );
  }
}

class AddToSpaceDialog extends StatefulWidget with WatchItStatefulWidgetMixin {
  const AddToSpaceDialog({super.key, required this.room});

  final Room room;

  @override
  State<AddToSpaceDialog> createState() => _AddToSpaceDialogState();
}

class _AddToSpaceDialogState extends State<AddToSpaceDialog> {
  Room? _selectedSpace;

  @override
  Widget build(BuildContext context) {
    final spaces = watchPropertyValue((ChatModel m) => m.spaces);

    return ConfirmationDialog(
      title: Text(context.l10n.addToSpace),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: spaces
            .map(
              (space) => RadioGroup(
                groupValue: _selectedSpace,
                onChanged: (value) => setState(() => _selectedSpace = value),

                child: RadioListTile<Room>(
                  title: Text(space.getLocalizedDisplayname()),
                  value: space,
                  enabled:
                      space.canEditSpace == true &&
                      !space.spaceChildren
                          .map((c) => c.roomId)
                          .contains(widget.room.id),
                ),
              ),
            )
            .toList(),
      ),
      confirmEnabled: _selectedSpace != null,
      onConfirm: () => showFutureLoadingDialog(
        context: context,
        future: () => di<CreateOrEditRoomModel>().addToSpace(
          widget.room,
          _selectedSpace!,
        ),
      ),
    );
  }
}
