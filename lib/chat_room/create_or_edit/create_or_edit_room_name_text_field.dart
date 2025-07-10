import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import '../../common/chat_model.dart';
import '../../common/view/save_text_icon.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/theme.dart';
import '../../l10n/l10n.dart';
import 'create_or_edit_room_model.dart';

class CreateOrEditRoomNameTextField extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const CreateOrEditRoomNameTextField({super.key, this.room});

  final Room? room;

  @override
  State<CreateOrEditRoomNameTextField> createState() =>
      _CreateOrEditRoomNameTextFieldState();
}

class _CreateOrEditRoomNameTextFieldState
    extends State<CreateOrEditRoomNameTextField> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room?.name);
  }

  @override
  Widget build(BuildContext context) {
    final enabledNameField = widget.room == null
        ? true
        : watchStream(
                (ChatModel m) => m
                    .getJoinedRoomUpdate(widget.room!.id)
                    .map(
                      (_) =>
                          widget.room!.canChangeStateEvent(EventTypes.RoomName),
                    ),
                initialValue: widget.room!.canChangeStateEvent(
                  EventTypes.RoomName,
                ),
                preserveState: false,
              ).data ??
              false;

    final l10n = context.l10n;
    final isSpace = watchPropertyValue((CreateOrEditRoomModel m) => m.isSpace);
    final name = watchPropertyValue((CreateOrEditRoomModel m) => m.name);

    return TextField(
      controller: _nameController,
      autofocus: true,
      enabled: enabledNameField,
      onChanged: di<CreateOrEditRoomModel>().setName,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        label: Text(isSpace ? l10n.spaceName : l10n.groupName),
        suffixIcon: (widget.room != null && enabledNameField)
            ? IconButton(
                padding: EdgeInsets.zero,
                style: textFieldSuffixStyle,
                onPressed: name != widget.room!.name
                    ? () => showFutureLoadingDialog(
                        context: context,
                        future: () => di<CreateOrEditRoomModel>()
                            .changeRoomName(widget.room!),
                        onError: (e) {
                          showErrorSnackBar(context, e);
                          return e;
                        },
                      )
                    : null,
                icon: SaveTextIcon(
                  room: widget.room,
                  textEditingController: _nameController,
                  isSaved: () => name == widget.room?.name,
                ),
              )
            : null,
      ),
    );
  }
}
