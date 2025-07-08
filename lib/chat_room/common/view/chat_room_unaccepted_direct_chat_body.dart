import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';

class ChatRoomUnacceptedDirectChatBody extends StatelessWidget {
  const ChatRoomUnacceptedDirectChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: kMediumPadding,
          children: [
            Icon(YaruIcons.send, size: 48, color: colorScheme.error),
            Text(
              l10n.waitingPartnerAcceptRequest,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
