import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../l10n/l10n.dart';
import '../settings_model.dart';

class ReactionsSection extends StatefulWidget {
  const ReactionsSection({super.key});

  @override
  State<ReactionsSection> createState() => _ReactionsSectionState();
}

class _ReactionsSectionState extends State<ReactionsSection> {
  late final TextEditingController _emojiController;
  final MenuController _menuController = MenuController();

  @override
  void initState() {
    super.initState();

    _emojiController = TextEditingController(
      text: (di<SettingsModel>().defaultReactions.isEmpty
              ? di<SettingsModel>().fallbackReactions
              : di<SettingsModel>().defaultReactions)
          .map((e) => e.trim())
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll(',', ''),
    );
  }

  @override
  void dispose() {
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return YaruSection(
      headline: const Text('Message reactions'),
      child: Column(
        children: [
          YaruTile(
            subtitle: const Text('Insert 6 emojis split by a comma'),
            title: MenuAnchor(
              menuChildren: [
                SizedBox(
                  height: 300,
                  width: 420,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) => _emojiController
                        .text = '${_emojiController.text}${emoji.emoji}',
                    config: emojiPickerConfig(theme: context.theme),
                  ),
                ),
              ],
              controller: _menuController,
              child: SizedBox(
                height: 38,
                child: TextField(
                  onTap: _menuController.open,
                  controller: _emojiController,
                  onSubmitted: (v) => submit(v),
                  decoration: InputDecoration(
                    suffix: Center(
                      widthFactor: 0.4,
                      child: IconButton(
                        style: textFieldSuffixStyle,
                        onPressed: () => submit(_emojiController.text),
                        icon: const Icon(YaruIcons.save),
                      ),
                    ),
                    label: const Text('Default Emojis'),
                    hintText: l10n.emojis,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submit(String v) {
    _emojiController.text = _emojiController.text.characters
        .where((e) => stringContainsEmoji(e))
        .string;
    var list = v.characters
        .map((e) => e)
        .where((e) => stringContainsEmoji(e))
        .toList();
    di<SettingsModel>().setDefaultReactions(
      list,
    );
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
