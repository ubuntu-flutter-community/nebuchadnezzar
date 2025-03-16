import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';

import '../../chat_room/common/view/chat_create_or_edit_room_dialog.dart';
import '../../common/chat_model.dart';
import '../../common/search_model.dart';

class ChatSpaceControlPanel extends StatelessWidget with WatchItMixin {
  const ChatSpaceControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final activeSpace = watchPropertyValue((ChatModel m) => m.activeSpace);
    final spaceSearch = watchPropertyValue((SearchModel m) => m.spaceSearch);
    return Padding(
      padding: const EdgeInsets.only(
        left: kMediumPlusPadding,
        right: kMediumPlusPadding,
        top: kMediumPadding,
        bottom: kMediumPadding,
      ),
      child: Row(
        spacing: kMediumPadding,
        children: [
          SizedBox.square(
            dimension: kAvatarDefaultSize,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => ChatCreateOrEditRoomDialog(
                  room: activeSpace,
                ),
              ),
              child: const Icon(
                YaruIcons.pen,
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: spaceSearch == null || activeSpace == null
                  ? null
                  : () => di<SearchModel>().searchSpaces(
                        activeSpace,
                        onFail: (e) => showSnackBar(context, content: Text(e)),
                      ),
              child: Text(context.l10n.discover),
            ),
          ),
          SizedBox.square(
            dimension: kAvatarDefaultSize,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () => di<ChatModel>().leaveSelectedRoom(
                room: activeSpace,
                onFail: (e) => showSnackBar(context, content: Text(e)),
              ),
              child: const Icon(
                YaruIcons.log_out,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
