import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';
import '../../chat_room/create_or_edit/create_or_edit_room_model.dart';
import '../../common/chat_model.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/sliver_sticky_panel.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';

class ChatMasterActiveSpaceInfo extends StatelessWidget with WatchItMixin {
  const ChatMasterActiveSpaceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textTheme = theme.textTheme;
    final activeSpace = watchPropertyValue((ChatModel m) => m.activeSpace);

    if (activeSpace == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final roomName =
        watchStream(
          (CreateOrEditRoomModel m) => m.getJoinedRoomNameStream(activeSpace),
          initialValue: activeSpace.name,
          preserveState: false,
        ).data ??
        activeSpace.name;

    final canonicalAlias =
        watchStream(
          (CreateOrEditRoomModel m) =>
              m.getJoinedRoomCanonicalAliasStream(activeSpace),
          initialValue: activeSpace.canonicalAlias,
          preserveState: false,
        ).data ??
        activeSpace.canonicalAlias;

    return SliverStickyPanel(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(
          left: kSmallPadding,
          right: kSmallPadding,
          top: kSmallPadding,
        ),
        child: ListTile(
          title: Text(roomName),
          subtitle: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              borderRadius: BorderRadius.circular(kSmallPadding),
              onTap: () => showSnackBar(
                context,
                content: CopyClipboardContent(text: activeSpace.canonicalAlias),
              ),
              child: Text(
                canonicalAlias,
                style: textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.link,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
