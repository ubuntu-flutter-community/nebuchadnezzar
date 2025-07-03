import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../common/date_time_x.dart';
import '../../common/event_x.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/confirm.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatEventInspectDialog extends StatelessWidget {
  const ChatEventInspectDialog({
    super.key,
    required this.event,
    required this.child,
  });

  final Event event;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final originalSource = event.originalSource;
    return ConfirmationDialog(
      contentPadding: EdgeInsets.zero,
      title: Text(
        event.senderFromMemoryOrFallback.displayName ?? event.eventId,
      ),
      content: SizedBox(
        height: 500,
        width: 400,
        child: ListView(
          children: [
            ListTile(
              leading: ChatAvatar(
                avatarUri: event.senderFromMemoryOrFallback.avatarUrl,
              ),
              title: Text(l10n.sender),
              subtitle: Text(
                '${event.senderFromMemoryOrFallback.calcDisplayname()} [${event.senderId}]',
              ),
            ),
            ListTile(
              title: Text('${l10n.time}:'),
              subtitle: Text(event.originServerTs.formatAndLocalize(context)),
            ),
            ListTile(
              title: Text('${l10n.status}:'),
              subtitle: Text(event.status.name),
            ),
            ListTile(title: Text('${l10n.sourceCode}:')),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Material(
                borderRadius: const BorderRadius.all(kBubbleRadius),
                color: getTileColor(event.isUserEvent, theme),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  scrollDirection: Axis.horizontal,
                  child: SelectableText(
                    improveJson(MatrixEvent.fromJson(event.toJson())),
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ),
              ),
            ),
            if (originalSource != null) ...[
              ListTile(title: Text('${l10n.encrypted}:')),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Material(
                  borderRadius: const BorderRadius.all(kBubbleRadius),
                  color: getTileColor(event.isUserEvent, theme),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      improveJson(originalSource),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String improveJson(MatrixEvent event) => const JsonEncoder.withIndent(
    '    ',
  ).convert(const JsonDecoder().convert(jsonEncode(event.toJson())));
}
