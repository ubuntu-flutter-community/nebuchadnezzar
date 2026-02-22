import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../../app/view/error_page.dart';
import '../../../app/view/mouse_and_keyboard_command_wrapper.dart';
import '../../../common/chat_manager.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/confirm.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../create_or_edit/create_room_manager.dart';
import '../../create_or_edit/edit_room_manager.dart';
import '../../info_drawer/chat_room_info_drawer.dart';
import '../../input/draft_manager.dart';
import '../../input/view/chat_input.dart';
import '../../timeline/chat_room_timeline_list.dart';
import '../../timeline/timeline_manager.dart';
import '../../titlebar/chat_room_title_bar.dart';
import 'chat_join_mixin.dart';

final GlobalKey<ScaffoldState> chatRoomScaffoldKey = GlobalKey();

class ChatRoomPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatRoomPage({required this.room, super.key});

  final Room room;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> with ChatJoinMixin {
  late final Future<Timeline> _timelineFuture;
  final GlobalKey<AnimatedListState> _roomListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    di<DraftManager>().resetThreadIds();
    _timelineFuture = di<TimelineManager>().loadTimeline(
      widget.room,
      onNewEvent: () => _roomListKey.currentState?.setState(() {}),
      onChange: (i) => _roomListKey.currentState?.setState(() {}),
      onInsert: (i) => _roomListKey.currentState?.insertItem(i),
      onRemove: (i) =>
          _roomListKey.currentState?.removeItem(i, (_, _) => const ListTile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    registerJoinHandlers(context);

    final knockIngOrJoining = watchValue(
      (EditRoomManager m) => m.knockOrJoinCommand.isRunning,
    );

    final joining = watchValue(
      (EditRoomManager m) => m.joinRoomCommand.isRunning,
    );

    final joiningDirectChat = watchValue(
      (CreateRoomManager m) => m.createOrGetDirectChatCommand.isRunning,
    );

    if (knockIngOrJoining || joining || joiningDirectChat) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Progress(),
              const SizedBox(height: kMediumPadding),
              Text(context.l10n.joiningRoomPleaseWait),
            ],
          ),
        ),
      );
    }

    final l10n = context.l10n;

    final threadeMode = watchPropertyValue((DraftManager m) => m.threadMode);

    registerStreamHandler(
      select: (ChatManager m) => m.getLeftRoomStream(widget.room.id),
      handler: (context, leftRoomUpdate, cancel) {
        if (!di<ChatManager>().archiveActive && leftRoomUpdate.hasData) {
          di<ChatManager>().setSelectedRoom(null);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ConfirmationDialog(
              showCancel: false,
              showCloseIcon: false,
              title: Text(widget.room.getLocalizedDisplayname()),
              content: Text(l10n.youAreNoLongerParticipatingInThisChat),
            ),
          );
        }
      },
    );

    return MouseAndKeyboardCommandWrapper(
      child: DropRegion(
        formats: Formats.standardFormats,
        hitTestBehavior: HitTestBehavior.opaque,
        onPerformDrop: (e) async {
          for (var item in e.session.items.take(5)) {
            item.dataReader?.getValue(
              Formats.fileUri,
              (value) async {
                if (value == null) return;
                final file = File.fromUri(value);

                await di<DraftManager>().addAttachment(
                  widget.room.id,
                  existingFiles: [
                    XFile(
                      value.toFilePath(),
                      name: file.path.split(Platform.pathSeparator).last,
                      mimeType: lookupMimeType(file.path),
                    ),
                  ],
                );
              },
              onError: (e) =>
                  showSnackBar(context, content: Text(e.toString())),
            );
          }
        },
        onDropOver: (event) {
          if (event.session.allowedOperations.contains(DropOperation.copy)) {
            return DropOperation.copy;
          } else {
            return DropOperation.none;
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              key: chatRoomScaffoldKey,
              endDrawer: const ChatRoomInfoDrawer(),
              appBar: ChatRoomTitleBar(room: widget.room),
              bottomNavigationBar: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child:
                    widget.room.isArchived || widget.room.isSpace || threadeMode
                    ? const SizedBox.shrink()
                    : ChatInput(
                        key: ValueKey('${widget.room.id}_input'),
                        room: widget.room,
                      ),
              ),
              body: FutureBuilder<Timeline>(
                key: ValueKey(widget.room.id),
                future: _timelineFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorBody(error: snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: kMediumPadding),
                      child: ChatRoomTimelineList(
                        timeline: snapshot.data!,
                        listKey: _roomListKey,
                      ),
                    );
                  } else {
                    return const Center(child: Progress());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
