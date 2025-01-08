import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

class ChatInvitationDialog extends StatelessWidget with WatchItMixin {
  const ChatInvitationDialog({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Invitation: ${room.name}'),
        actions: [],
      );
}
