import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/view/confirm.dart';
import '../../l10n/l10n.dart';
import 'chat_html_message.dart';

class ChatTextMessage extends StatelessWidget {
  const ChatTextMessage({
    super.key,
    required this.displayEvent,
    this.messageStyle,
  });

  final Event displayEvent;
  final TextStyle? messageStyle;

  @override
  Widget build(BuildContext context) => displayEvent.isRichMessage
      ? HtmlMessage(displayEvent: displayEvent, style: messageStyle)
      : Linkify(
          text: displayEvent.body,
          style: messageStyle,
          onOpen: (link) {
            final maybe = Uri.tryParse(link.url);
            if (maybe != null) {
              showDialog(
                context: context,
                builder: (context) => ConfirmationDialog(
                  title: Text('${context.l10n.openLinkInBrowser}?'),
                  content: SizedBox(width: 400, child: Text(link.url)),
                  onConfirm: () => launchUrl(maybe),
                ),
              );
            }
          },
        );
}
