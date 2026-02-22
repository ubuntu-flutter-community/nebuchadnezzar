import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix_api_lite/generated/model.dart';

import '../../app/view/error_page.dart';
import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/chat_manager.dart';
import '../../common/search_manager.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatRoomSearchDialog extends StatefulWidget {
  const ChatRoomSearchDialog({super.key, required this.url});

  final String url;

  @override
  State<ChatRoomSearchDialog> createState() => _ChatRoomSearchDialogState();
}

class _ChatRoomSearchDialogState extends State<ChatRoomSearchDialog> {
  late Future<List<PublishedRoomsChunk>> _future;

  @override
  void initState() {
    super.initState();
    _future = di<SearchManager>().findPublicRoomChunks(
      widget.url
          .replaceAll('https://matrix.to/#/', '')
          .replaceAll('https://matrix.to/#/#', ''),
      onFail: (error) => showSnackBar(context, content: Text(error)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AlertDialog(
            content: ErrorBody(error: snapshot.error.toString()),
          );
        }

        final roomChunk = snapshot.data?.firstOrNull;
        return ConfirmationDialog(
          confirmEnabled: snapshot.hasData && snapshot.data!.isNotEmpty,
          confirmLabel:
              roomChunk != null &&
                  di<ChatManager>().getRoomById(roomChunk.roomId) != null
              ? l10n.openChat
              : l10n.joinRoom,
          onConfirm: roomChunk != null
              ? () {
                  final joinedRoom = di<ChatManager>().getRoomById(
                    roomChunk.roomId,
                  );

                  if (joinedRoom != null) {
                    di<ChatManager>().setSelectedRoom(joinedRoom);
                    return;
                  }
                  di<ChatManager>().setSelectedRoom(null);
                  di<EditRoomManager>().knockOrJoinCommand.run((
                    knock: roomChunk.joinRule == 'knock',
                    roomId: roomChunk.roomId,
                  ));
                }
              : null,
          title: Text(snapshot.hasData ? l10n.joinRoom : l10n.search),
          content: (snapshot.hasData)
              ? Column(
                  mainAxisSize: .min,
                  spacing: kMediumPadding,
                  children: [
                    if (snapshot.data!.isNotEmpty)
                      ChatAvatar(
                        avatarUri: snapshot.data!.first.avatarUrl,
                        dimension: 40,
                      ),
                    Flexible(
                      child: Text(
                        snapshot.data!.isNotEmpty
                            ? snapshot.data!.first.canonicalAlias ??
                                  snapshot.data!.first.roomId
                            : l10n.nothingFound,
                      ),
                    ),
                  ],
                )
              : const Progress(),
        );
      },
    );
  }
}
