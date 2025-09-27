import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:watch_it/watch_it.dart';

import '../../../app/view/error_page.dart';
import '../../../common/chat_manager.dart';
import '../../../common/room_x.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/confirm.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/theme.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../create_or_edit/edit_room_service.dart';
import '../../info_drawer/chat_room_info_drawer.dart';
import '../../input/draft_manager.dart';
import '../../input/view/chat_input.dart';
import '../../timeline/chat_room_timeline_list.dart';
import '../../timeline/timeline_manager.dart';
import '../../titlebar/chat_room_title_bar.dart';
import 'chat_room_unaccepted_direct_chat_body.dart';

final GlobalKey<ScaffoldState> chatRoomScaffoldKey = GlobalKey();

class ChatRoomPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatRoomPage({required this.room, super.key});

  final Room room;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final Future<Timeline> _timelineFuture;
  final GlobalKey<AnimatedListState> _roomListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
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
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final updating = watchPropertyValue(
      (TimelineManager m) => m.getUpdatingTimeline(widget.room.id),
    );

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

    final unAcceptedDirectChat = !widget.room.isUnacceptedDirectChat
        ? false
        : watchStream(
            (EditRoomService m) => m
                .getUsersStreamOfJoinedRoom(
                  widget.room,
                  membershipFilter: [Membership.invite],
                )
                .map(
                  (invitedUsers) =>
                      widget.room.isDirectChat && invitedUsers.isNotEmpty,
                ),
            initialValue: widget.room.isUnacceptedDirectChat,
            preserveState: false,
          ).data;

    return DropRegion(
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
                onFail: (error) => showSnackBar(context, content: Text(error)),
                existingFiles: [XFile.fromData(file.readAsBytesSync())],
              );
            },
            onError: (e) => showSnackBar(context, content: Text(e.toString())),
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
            endDrawer: ChatRoomInfoDrawer(room: widget.room),
            appBar: ChatRoomTitleBar(room: widget.room),
            bottomNavigationBar:
                widget.room.isArchived ||
                    unAcceptedDirectChat != false ||
                    widget.room.isSpace
                ? null
                : ChatInput(
                    key: ValueKey('${widget.room.id}input'),
                    room: widget.room,
                  ),
            body: unAcceptedDirectChat == null
                ? const Center(child: Progress())
                : unAcceptedDirectChat == true
                ? const ChatRoomUnacceptedDirectChatBody()
                : FutureBuilder<Timeline>(
                    key: ValueKey(widget.room.id),
                    future: _timelineFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return ErrorBody(error: snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: kMediumPadding,
                          ),
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
          if (updating &&
              chatRoomScaffoldKey.currentState?.isEndDrawerOpen != true)
            Positioned(
              top: 4 * kBigPadding,
              child: RepaintBoundary(
                child: CircleAvatar(
                  backgroundColor: getMonochromeBg(
                    theme: context.theme,
                    factor: 3,
                    darkFactor: 4,
                  ),
                  maxRadius: 15,
                  child: SizedBox.square(
                    dimension: 18,
                    child: Progress(
                      strokeWidth: 2,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
