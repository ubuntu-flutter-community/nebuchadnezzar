import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:html/dom.dart' as dom;
import 'package:matrix/matrix_api_lite/generated/model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';

import '../../app/view/error_page.dart';
import '../../chat_room/create_or_edit/create_or_edit_room_model.dart';
import '../../common/chat_model.dart';
import '../../common/search_model.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/chat_profile_dialog.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

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

class ChatRoomSearchDialog extends StatefulWidget {
  const ChatRoomSearchDialog({super.key, required this.url});

  final String url;

  @override
  State<ChatRoomSearchDialog> createState() => _ChatRoomSearchDialogState();
}

class _ChatRoomSearchDialogState extends State<ChatRoomSearchDialog> {
  late Future<List<PublicRoomsChunk>> _future;

  @override
  void initState() {
    super.initState();
    _future = di<SearchModel>().findPublicRoomChunks(
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
                  di<ChatModel>().getRoomById(roomChunk.roomId) != null
              ? l10n.openChat
              : l10n.joinRoom,
          onConfirm: roomChunk != null
              ? () {
                  final joinedRoom = di<ChatModel>().getRoomById(
                    roomChunk.roomId,
                  );

                  if (joinedRoom != null) {
                    di<ChatModel>().setSelectedRoom(joinedRoom);
                    return Future.value();
                  }

                  return showFutureLoadingDialog(
                    context: context,
                    future: () => di<CreateOrEditRoomModel>()
                        .knockOrJoinRoomChunk(roomChunk),
                  ).then((result) {
                    if (result.asValue?.value != null) {
                      di<ChatModel>().setSelectedRoom(result.asValue!.value!);
                    }
                  });
                }
              : null,
          title: Text(snapshot.hasData ? l10n.joinRoom : l10n.search),
          content: SizedBox(
            height: 80,
            width: 200,
            child: (snapshot.hasData)
                ? Center(
                    child: Column(
                      spacing: kMediumPadding,
                      children: [
                        if (snapshot.data!.isNotEmpty)
                          ChatAvatar(
                            avatarUri: snapshot.data!.first.avatarUrl,
                            dimension: 40,
                          ),
                        Text(
                          snapshot.data!.isNotEmpty
                              ? snapshot.data!.first.canonicalAlias ??
                                    snapshot.data!.first.roomId
                              : l10n.nothingFound,
                        ),
                      ],
                    ),
                  )
                : const Center(child: Progress()),
          ),
        );
      },
    );
  }
}
