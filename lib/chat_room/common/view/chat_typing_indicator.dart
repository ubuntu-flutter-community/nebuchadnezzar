import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/theme.dart';
import '../../../common/view/ui_constants.dart';
import '../../../common/chat_manager.dart';
import '../../../common/view/chat_avatar.dart';

class ChatTypingIndicator extends StatelessWidget with WatchItMixin {
  final Room room;

  const ChatTypingIndicator({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final typingUsers =
        watchStream(
          (ChatManager m) => m.getTypingUsersStream(room),
          initialValue: room.typingUsers,
        ).data ??
        [];

    return AnimatedContainer(
      height: typingUsers.isEmpty ? 0 : kTypingAvatarSize,
      duration: kAvatarAnimationDuration,
      curve: kAvatarAnimationCurve,
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: kBigPadding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: kSmallPadding,
        children: [
          ...typingUsers.map(
            (e) => ChatAvatar(
              key: ValueKey(e.id),
              dimension: kTypingAvatarSize,
              fallBackIconSize: kTypingAvatarSize / 2,
              avatarUri: e.avatarUrl,
            ),
          ),
          Material(
            color: getMonochromeBg(theme: theme, factor: 6, darkFactor: 15),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            elevation: 0.1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
              child: typingUsers.isEmpty ? null : const _TypingDots(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => __TypingDotsState();
}

class __TypingDotsState extends State<_TypingDots> {
  int _tick = 0;

  late final Timer _timer;

  static const Duration animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(animationDuration, (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _tick = (_tick + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    const size = kTypingAvatarSize / 3;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 3; i++)
            AnimatedContainer(
              duration: animationDuration * 1.5,
              curve: Curves.bounceIn,
              width: size,
              height: _tick == i ? size * 3 : size,
              margin: const EdgeInsets.symmetric(horizontal: size / 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 2),
                color: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}
