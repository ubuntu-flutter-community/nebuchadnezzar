import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/theme.dart';

class ChatEmojiPicker extends StatelessWidget {
  const ChatEmojiPicker({
    super.key,
    this.onEmojiSelected,
  });

  final void Function(Category?, Emoji)? onEmojiSelected;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 300,
          maxHeight: 300,
          minWidth: 300,
          maxWidth: 300,
        ),
        child: EmojiPicker(
          onEmojiSelected: onEmojiSelected,
          config: emojiPickerConfig(theme: context.theme),
        ),
      );
}

class ChatInputEmojiMenu extends StatefulWidget {
  const ChatInputEmojiMenu({
    super.key,
    required this.onEmojiSelected,
  });

  final void Function(Category?, Emoji)? onEmojiSelected;

  @override
  State<ChatInputEmojiMenu> createState() => _ChatInputEmojiMenuState();
}

class _ChatInputEmojiMenuState extends State<ChatInputEmojiMenu> {
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
        ChatEmojiPicker(
          onEmojiSelected: (p0, p1) {
            widget.onEmojiSelected?.call(p0, p1);
            _controller?.close();
          },
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
