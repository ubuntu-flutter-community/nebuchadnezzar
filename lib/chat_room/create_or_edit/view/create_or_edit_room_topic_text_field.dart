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
  late final TextEditingController _topicController;
  late final String _initialText;

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController(text: widget.room?.topic);
    _initialText = _topicController.text;
  }

  @override
  Widget build(BuildContext context) {
    final enabledTopicField = widget.room == null
        ? true
        : watchStream(
                (EditRoomService m) =>
                    m.getJoinedRoomCanChangeTopicStream(widget.room!),
                initialValue: widget.room!.canChangeTopic,
                preserveState: false,
              ).data ??
              false;

    final l10n = context.l10n;

    final roomTopic = widget.room == null
        ? null
        : watchStream(
                (EditRoomService m) => m.getJoinedRoomTopicStream(widget.room!),
                initialValue: widget.room!.topic,
                preserveState: false,
              ).data ??
              widget.room!.topic;

    return ListenableBuilder(
      listenable: _topicController,
      builder: (context, _) {
        final topicIsSynced = _topicController.text == roomTopic;
        final draftWasChanged = _initialText != _topicController.text;
        return TextField(
          controller: _topicController,
          autofocus: true,
          enabled: enabledTopicField,
          onChanged: (v) => di<CreateRoomManager>().updateDraft(topic: v),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            label: Text(l10n.chatDescription),
            suffixIcon: (widget.room != null && enabledTopicField)
                ? IconButton(
                    padding: EdgeInsets.zero,
                    style: textFieldSuffixStyle,
                    onPressed: topicIsSynced
                        ? null
                        : () => showFutureLoadingDialog(
                            context: context,
                            onError: (e) {
                              _topicController.clear();
                              return e.toString();
                            },
                            future: () => di<EditRoomService>().changeRoomTopic(
                              widget.room!,
                              _topicController.text,
                            ),
                          ),
                    icon: topicIsSynced
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
