import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../../../common/view/build_context_x.dart';

class ChatEmojiPicker extends StatelessWidget {
  const ChatEmojiPicker({
    super.key,
    this.onEmojiSelected,
  });

  final void Function(Category?, Emoji)? onEmojiSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final theme = context.theme;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 300,
        maxHeight: 300,
        minWidth: 300,
        maxWidth: 300,
      ),
      child: EmojiPicker(
        onEmojiSelected: onEmojiSelected,
        config: Config(
          customSearchIcon: const Icon(YaruIcons.search),
          customBackspaceIcon: const Icon(YaruIcons.edit_clear),
          emojiViewConfig: const EmojiViewConfig(
            verticalSpacing: 0,
            horizontalSpacing: 0,
            emojiSizeMax: 25,
            backgroundColor: Colors.transparent,
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            backgroundColor: colorScheme.surface,
            buttonIconColor: colorScheme.primary,
            buttonColor: colorScheme.surface,
          ),
          skinToneConfig: const SkinToneConfig(
            dialogBackgroundColor: Colors.transparent,
          ),
          categoryViewConfig: CategoryViewConfig(
            initCategory: Category.SMILEYS,
            indicatorColor: colorScheme.onSurface,
            iconColorSelected: colorScheme.primary,
            backspaceColor: theme.primaryColor,
            backgroundColor: Colors.transparent,
            iconColor: colorScheme.onSurface,
          ),
          searchViewConfig: SearchViewConfig(
            backgroundColor: Colors.transparent,
            buttonIconColor: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class ChatInputEmojiMenu extends StatefulWidget {
  const ChatInputEmojiMenu({
    super.key,
    required this.onEmojiSelected,
  });

  final void Function(Category?, Emoji) onEmojiSelected;

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
            widget.onEmojiSelected(p0, p1);
            _controller?.close();
          },
        ),
      ],
      child: IconButton(
        onPressed: () {
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
