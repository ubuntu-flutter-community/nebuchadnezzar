import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../events/view/chat_html_message_link_handler.dart';

class ChatRoomInfoDrawerTopic extends StatelessWidget with WatchItMixin {
  const ChatRoomInfoDrawerTopic({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final topic =
        watchStream(
          (ChatManager m) =>
              m.getJoinedRoomUpdate(room.id).map((_) => room.topic),
          initialValue: room.topic,
        ).data ??
        room.topic;

    return Padding(
      padding: const EdgeInsets.only(bottom: kMediumPadding),
      child: ListTile(
        dense: true,
        title: Html(
          onLinkTap: (url, attributes, element) =>
              chatHtmlMessageLinkHandler(url, attributes, element, context),
          data: topic,
          style: {
            'a': Style.fromTextStyle(
              context.textTheme.bodyMedium!,
            ).copyWith(color: context.colorScheme.link),
            'body': Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              textAlign: TextAlign.center,
              fontSize: FontSize(12),
            ),
          },
        ),
      ),
    );
  }
}
