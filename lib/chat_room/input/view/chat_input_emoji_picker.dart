import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/theme.dart';

class ChatInputEmojiPicker extends StatefulWidget {
  const ChatInputEmojiPicker({super.key, required this.onEmojiSelected});

  final void Function(Category?, Emoji)? onEmojiSelected;

  @override
  State<ChatInputEmojiPicker> createState() => _ChatInputEmojiPickerState();
}

class _ChatInputEmojiPickerState extends State<ChatInputEmojiPicker> {
  MenuController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = MenuController();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: const Offset(-40, 12),
      controller: _controller,
      menuChildren: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 300,
            maxHeight: 300,
            minWidth: 300,
            maxWidth: 300,
          ),
          child: EmojiPicker(
            onEmojiSelected: (p0, p1) {
              widget.onEmojiSelected?.call(p0, p1);
              _controller?.close();
            },
            config: emojiPickerConfig(theme: context.theme),
          ),
        ),
      ],
      child: IconButton(
        onPressed: widget.onEmojiSelected == null
            ? null
            : () {
                if (_controller?.isOpen == true) {
                  _controller?.close();
                } else {
                  _controller?.open();
                }
                setState(() {});
              },
        icon: const Icon(YaruIcons.emote_smile),
        selectedIcon: const Icon(YaruIcons.emote_smile_big_filled),
      ),
    );
  }
}
