import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../settings/settings_model.dart';

class ChatMessageMenuReactionPicker extends StatelessWidget with WatchItMixin {
  const ChatMessageMenuReactionPicker({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final defaultReactions = watchPropertyValue(
      (SettingsModel m) => m.defaultReactions,
    );
    return YaruExpandable(
      expandButtonPosition: YaruExpandableButtonPosition.start,
      gapHeight: 0,
      expandIconPadding: const EdgeInsets.only(
        bottom: kSmallPadding,
        left: kMediumPadding,
      ),
      header: SizedBox(
        width: 220,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: kSmallPadding,
            left: kSmallPadding,
            right: kSmallPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: defaultReactions
                .map(
                  (e) => IconButton(
                    onPressed: () => showFutureLoadingDialog(
                      context: context,
                      onError: (error) {
                        showErrorSnackBar(context, error);
                        return error;
                      },
                      future: () => event.room.sendReaction(event.eventId, e),
                    ),
                    icon: Text(e),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      child: SizedBox(
        width: 275,
        height: 220,
        child: EmojiPicker(
          config: emojiPickerConfig(
            theme: context.theme,
            emojiSizeMax: 15,
            bottom: false,
          ),
          onEmojiSelected: (category, emoji) =>
              event.room.sendReaction(event.eventId, emoji.emoji),
        ),
      ),
    );
  }
}
