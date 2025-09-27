import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/theme.dart';
import '../../../extensions/room_x.dart';
import '../../../l10n/l10n.dart';
import '../create_room_manager.dart';
import '../edit_room_service.dart';

class CreateOrEditRoomNameTextField extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const CreateOrEditRoomNameTextField({
    super.key,
    this.room,
    required this.isSpace,
  });

  final Room? room;
  final bool isSpace;

  @override
  State<CreateOrEditRoomNameTextField> createState() =>
      _CreateOrEditRoomNameTextFieldState();
}

class _CreateOrEditRoomNameTextFieldState
    extends State<CreateOrEditRoomNameTextField> {
  late final TextEditingController _nameController;
  late final String _initialText;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room?.name);
    _initialText = _nameController.text;
  }

  @override
  Widget build(BuildContext context) {
    final enabledNameField = widget.room == null
        ? true
        : watchStream(
                (EditRoomService m) =>
                    m.getJoinedRoomCanChangeNameStream(widget.room!),
                initialValue: widget.room!.canChangeName,
                preserveState: false,
              ).data ??
              false;

    final l10n = context.l10n;
    final roomName = widget.room == null
        ? null
        : watchStream(
                (EditRoomService m) => m.getJoinedRoomNameStream(widget.room!),
                initialValue: widget.room!.name,
                preserveState: false,
              ).data ??
              widget.room!.name;

    return ListenableBuilder(
      listenable: _nameController,
      builder: (context, _) {
        final nameIsSynced = _nameController.text == roomName;
        final draftWasChanged = _initialText != _nameController.text;
        return TextField(
          controller: _nameController,
          autofocus: true,
          enabled: enabledNameField,
          onChanged: (v) => di<CreateRoomManager>().nameDraft.value = v,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            label: Text(widget.isSpace ? l10n.spaceName : l10n.groupName),
            suffixIcon: (widget.room != null && enabledNameField)
                ? IconButton(
                    padding: EdgeInsets.zero,
                    style: textFieldSuffixStyle,
                    onPressed: nameIsSynced
                        ? null
                        : () => showFutureLoadingDialog(
                            context: context,
                            onError: (e) {
                              _nameController.clear();
                              return e.toString();
                            },
                            future: () => di<EditRoomService>().changeRoomName(
                              widget.room!,
                              _nameController.text,
                            ),
                          ),
                    icon: nameIsSynced
                        ? YaruAnimatedVectorIcon(
                            YaruAnimatedIcons.ok_filled,
                            color: draftWasChanged
                                ? context.colorScheme.success
                                : null,
                          )
                        : const Icon(YaruIcons.save),
                  )
                : null,
          ),
        );
      },
    );
  }
}
