import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/room_x.dart';
import '../../common/view/build_context_x.dart';
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
                (CreateOrEditRoomModel m) =>
                    m.getJoinedRoomCanChangeNameStream(widget.room!),
                initialValue: widget.room!.canChangeName,
                preserveState: false,
              ).data ??
              false;

    final l10n = context.l10n;
    final isSpace = watchPropertyValue((CreateOrEditRoomModel m) => m.isSpace);
    final nameDraft = watchPropertyValue(
      (CreateOrEditRoomModel m) => m.nameDraft,
    );
    final roomName = widget.room == null
        ? null
        : watchStream(
                (CreateOrEditRoomModel m) =>
                    m.getJoinedRoomNameStream(widget.room!),
                initialValue: widget.room!.name,
                preserveState: false,
              ).data ??
              widget.room!.name;

    final nameIsSynced = nameDraft == roomName;
    final draftWasChanged = _initialText != nameDraft;

    return TextField(
      controller: _nameController,
      autofocus: true,
      enabled: enabledNameField,
      onChanged: di<CreateOrEditRoomModel>().setNameDraft,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        label: Text(isSpace ? l10n.spaceName : l10n.groupName),
        suffixIcon: (widget.room != null && enabledNameField)
            ? IconButton(
                padding: EdgeInsets.zero,
                style: textFieldSuffixStyle,
                onPressed: nameIsSynced
                    ? null
                    : () => showFutureLoadingDialog(
                        context: context,
                        future: () => di<CreateOrEditRoomModel>()
                            .changeRoomName(widget.room!, nameDraft),
                        onError: (e) {
                          showErrorSnackBar(context, e);
                          return e;
                        },
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
  }
}
