import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import 'chat_html_message.dart';

class ChatTextMessage extends StatelessWidget {
  const ChatTextMessage({
    super.key,
    required this.event,
    required this.displayEvent,
    this.messageStyle,
  });

  final Event event;
  final Event displayEvent;
  final TextStyle? messageStyle;

  @override
  Widget build(BuildContext context) => event.isRichMessage
      ? HtmlMessage(
          html: event.formattedText,
          room: event.room,
          style: messageStyle,
        )
      : SelectableText.rich(
          TextSpan(
            style: messageStyle,
            text: displayEvent.body,
          ),
          style: messageStyle,
        );
}
