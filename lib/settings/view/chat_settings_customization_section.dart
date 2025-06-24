import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../settings_model.dart';

class ChatSettingsCustomizationSection extends StatefulWidget {
  const ChatSettingsCustomizationSection({super.key});

  @override
  State<ChatSettingsCustomizationSection> createState() =>
      _ChatSettingsCustomizationSectionState();
}

class _ChatSettingsCustomizationSectionState
    extends State<ChatSettingsCustomizationSection> {
  bool saved = false;
  late final TextEditingController _textController;
  final MenuController _menuController = MenuController();
  final double height = 38.0;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(
      text: di<SettingsModel>().defaultReactions.join(),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return YaruSection(
      headline: const Text('Customization'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: kMediumPadding,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: kSmallPadding,
                bottom: kSmallPadding,
              ),
              child: MenuAnchor(
                menuChildren: [
                  SizedBox(
                    height: 300,
                    width: 420,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        setState(() => saved = false);
                        _textController.text = _textController.text.length >= 12
                            ? emoji.emoji
                            : '${_textController.text}${emoji.emoji}';
                      },
                      config: emojiPickerConfig(theme: context.theme),
                    ),
                  ),
                ],
                controller: _menuController,
                child: TextField(
                  onTap: () {
                    _textController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _textController.value.text.length,
                    );
                    _menuController.open();
                  },
                  controller: _textController,
                  onSubmitted: (v) => submit(v),
                  decoration: InputDecoration(
                    label: const Text('Select 6 emojis as quick reactions'),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      style: textFieldSuffixStyle,
                      onPressed: () {
                        _menuController.close();
                        submit(_textController.text);
                        setState(() => saved = true);
                      },
                      icon: saved
                          ? YaruAnimatedVectorIcon(
                              YaruAnimatedIcons.ok_filled,
                              color: context.colorScheme.success,
                            )
                          : Icon(
                              saved ? YaruIcons.checkmark : YaruIcons.save,
                              color: saved ? context.colorScheme.success : null,
                            ),
                    ),
                    hintText: l10n.emojis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit(String v) {
    _textController.text = _textController.text.characters
        .where((e) => stringContainsEmoji(e))
        .string;
    var list = v.characters
        .map((e) => e)
        .where((e) => stringContainsEmoji(e))
        .toList();
    di<SettingsModel>().setDefaultReactions(list);
  }
}

bool stringContainsEmoji(String text) {
  final characters = text.characters;
  for (final char in characters) {
    if (_isEmoji(char)) {
      return true;
    }
  }
  return false;
}

bool _isEmoji(String char) {
  // This is a simplified approach, as true emoji detection can be complex.
  // It checks for characters within common Unicode ranges for emojis.
  // For more robust detection, consider using a dedicated emoji library.

  final runes = char.runes;
  if (runes.isEmpty) {
    return false;
  }

  final firstRune = runes.first;

  // Basic emoji ranges. More sophisticated detection is required for all cases.
  if (firstRune >= 0x1F300 && firstRune <= 0x1F64F ||
      firstRune >= 0x1F680 && firstRune <= 0x1F6FF ||
      firstRune >= 0x2600 && firstRune <= 0x26FF ||
      firstRune >= 0x2700 && firstRune <= 0x27BF ||
      firstRune >= 0x1F900 && firstRune <= 0x1F9FF ||
      firstRune >= 0x1FA70 && firstRune <= 0x1FAFF ||
      firstRune >= 0x1F300 && firstRune <= 0x1F5FF ||
      firstRune >= 0xFE00 && firstRune <= 0xFE0F || // Variation selectors
      firstRune >= 0x10000 && firstRune <= 0x10FFFF) {
    // Supplementary Planes
    return true;
  }

  // Check for combining characters that might form emojis, like ZWJ sequences.
  if (runes.length > 1) {
    //check for regional indicators.
    if (runes.length == 2 &&
        runes.first >= 0x1F1E6 &&
        runes.first <= 0x1F1FF &&
        runes.last >= 0x1F1E6 &&
        runes.last <= 0x1F1FF) {
      return true;
    }

    //check for keycaps
    if (runes.length == 2 &&
        runes.last == 0x20E3 &&
        (runes.first >= 0x30 && runes.first <= 0x39 ||
            runes.first == 0x23 ||
            runes.first == 0x2A)) {
      return true;
    }

    //check for variation selectors.
    for (int i = 1; i < runes.length; i++) {
      if (runes.elementAt(i) >= 0xFE00 && runes.elementAt(i) <= 0xFE0F) {
        return true;
      }
    }
  }

  return false;
}
