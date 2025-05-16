import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../chat_model.dart';
import 'build_context_x.dart';

class SaveTextIcon extends StatefulWidget {
  const SaveTextIcon({
    super.key,
    this.room,
    required this.textEditingController,
    required this.isSaved,
  });

  final Room? room;
  final TextEditingController textEditingController;
  final bool Function() isSaved;

  @override
  State<SaveTextIcon> createState() => _SaveTextIconState();
}

class _SaveTextIconState extends State<SaveTextIcon> {
  late final String initialText;

  @override
  void initState() {
    super.initState();
    initialText = widget.textEditingController.text;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: di<ChatModel>().getJoinedRoomUpdate(widget.room?.id),
      builder: (context, snapshot) {
        return ListenableBuilder(
          listenable: widget.textEditingController,
          builder: (context, child) {
            final saved = widget.isSaved();
            return saved
                ? YaruAnimatedVectorIcon(
                    YaruAnimatedIcons.ok_filled,
                    color: initialText == widget.textEditingController.text
                        ? null
                        : context.colorScheme.success,
                  )
                : Icon(
                    saved ? YaruIcons.checkmark : YaruIcons.save,
                    color: saved ? context.colorScheme.success : null,
                  );
          },
        );
      },
    );
  }
}
