import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/event_x.dart';
import '../../settings/settings_manager.dart';
import '../chat_message_reaction_capsule.dart';
import '../chat_message_reaction_entry.dart';

class ChatMessageMenuReactionPicker extends StatelessWidget with WatchItMixin {
  const ChatMessageMenuReactionPicker({
    super.key,
    required this.event,
    required this.timeline,
  });

  final Event event;
  final Timeline timeline;

  @override
  Widget build(BuildContext context) {
    final defaultReactions = watchPropertyValue(
      (SettingsManager m) => m.defaultReactions,
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
                    onPressed: () {
                      final allReactionEvents = event.getAllReactionEvents(
                        timeline,
                      );
                      return di<EditRoomManager>()
                          .getSendReactionCommand(e + event.eventId)
                          .run(
                            ChatMessageReactionCapsule(
                              event: event,
                              allReactionEvents: allReactionEvents,
                              entry:
                                  event.getReactionMap(allReactionEvents)[e] ??
                                  ChatMessageReactionEntry(
                                    key: e,
                                    count: 0,
                                    reacted: false,
                                  ),
                            ),
                          );
                    },
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
