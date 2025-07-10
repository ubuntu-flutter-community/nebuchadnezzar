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

class CreateOrEditRoomTopicTextField extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const CreateOrEditRoomTopicTextField({super.key, this.room});

  final Room? room;

  @override
  State<CreateOrEditRoomTopicTextField> createState() =>
      _CreateOrEditRoomTopicTextFieldState();
}

class _CreateOrEditRoomTopicTextFieldState
    extends State<CreateOrEditRoomTopicTextField> {
  late final TextEditingController _groupTopicController;

  @override
  void initState() {
    super.initState();
    _groupTopicController = TextEditingController(text: widget.room?.topic);
  }

  @override
  Widget build(BuildContext context) {
    final enabledTopicField = widget.room == null
        ? true
        : watchStream(
                (ChatModel m) => m
                    .getJoinedRoomUpdate(widget.room!.id)
                    .map(
                      (_) => widget.room!.canChangeStateEvent(
                        EventTypes.RoomTopic,
                      ),
                    ),
                initialValue: widget.room!.canChangeStateEvent(
                  EventTypes.RoomTopic,
                ),
                preserveState: false,
              ).data ??
              false;

    final l10n = context.l10n;
    final topic = watchPropertyValue((CreateOrEditRoomModel m) => m.topic);

    return TextField(
      controller: _groupTopicController,
      enabled: enabledTopicField,
      onChanged: di<CreateOrEditRoomModel>().setTopic,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        label: Text(l10n.chatDescription),
        suffixIcon: (widget.room != null && enabledTopicField)
            ? IconButton(
                padding: EdgeInsets.zero,
                style: textFieldSuffixStyle,
                onPressed: topic != widget.room!.topic
                    ? () => showFutureLoadingDialog(
                        context: context,
                        future: () => di<CreateOrEditRoomModel>()
                            .changeRoomTopic(widget.room!),
                        onError: (e) {
                          showErrorSnackBar(context, e);
                          return e;
                        },
                      )
                    : null,
                icon: SaveTextIcon(
                  room: widget.room,
                  textEditingController: _groupTopicController,
                  isSaved: () => topic == widget.room?.topic,
                ),
              )
            : null,
      ),
    );
  }
}
