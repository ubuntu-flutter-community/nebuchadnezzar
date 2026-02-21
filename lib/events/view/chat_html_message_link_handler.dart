import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import '../../common/view/chat_profile_dialog.dart';
import '../../common/view/confirm.dart';
import '../../l10n/l10n.dart';
import 'chat_room_search_dialog.dart';

void chatHtmlMessageLinkHandler(
  String? url,
  Map<String, String> attributes,
  dom.Element? element,
  BuildContext context,
) {
  if (url == null) return;
  if (url.startsWith('https://matrix.to/#/@')) {
    showDialog(
      context: context,
      builder: (context) => ChatProfileDialog(
        userId: url.toString().replaceAll('https://matrix.to/#/', ''),
      ),
    );
  } else if (url.startsWith('https://matrix.to/#/#')) {
    showDialog(
      context: context,
      builder: (context) => ChatRoomSearchDialog(url: url),
    );
  } else if (Uri.tryParse(url) != null) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: Text('${context.l10n.openLinkInBrowser}?'),
        content: SizedBox(width: 400, child: Text(url)),
        onConfirm: () => launchUrl(Uri.parse(url)),
      ),
    );
  }
}
