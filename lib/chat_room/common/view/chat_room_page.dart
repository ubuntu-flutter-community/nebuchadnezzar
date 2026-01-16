import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:yaru/yaru.dart';

import '../../../app/view/error_page.dart';
import '../../../app/view/mouse_and_keyboard_command_wrapper.dart';
import '../../../common/chat_manager.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/confirm.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/theme.dart';
import '../../../common/view/ui_constants.dart';
import '../../../extensions/room_x.dart';
import '../../../l10n/l10n.dart';
import '../../info_drawer/chat_room_info_drawer.dart';
import '../../input/draft_manager.dart';
import '../../input/view/chat_input.dart';
import '../../timeline/chat_room_timeline_list.dart';
import '../../timeline/timeline_manager.dart';
import '../../titlebar/chat_room_title_bar.dart';

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
    _timelineFuture = di<TimelineManager>()
        .loadTimeline(
          widget.room,
          onNewEvent: () => _roomListKey.currentState?.setState(() {}),
          onChange: (i) => _roomListKey.currentState?.setState(() {}),
          onInsert: (i) => _roomListKey.currentState?.insertItem(i),
          onRemove: (i) => _roomListKey.currentState?.removeItem(
            i,
            (_, _) => const ListTile(),
          ),
        )
        .then((timeline) async {
          if (widget.room.isDirectChat) {
            await di<ChatManager>().awaitEncryptionEvent(widget.room);
          }
          return timeline;
        });
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

    final isUnacceptedDirectChat = widget.room.isDirectChat
        ? false
        : watchStream(
                (ChatManager m) => m.getPendingDirectChatStream(widget.room),
                initialValue: widget.room.isUnacceptedDirectChat,
              ).data ??
              false;

    if (isUnacceptedDirectChat) {
      return Scaffold(
        appBar: ChatRoomTitleBar(room: widget.room),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(kBigPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  YaruIcons.send,
                  size: 64,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                Text(
                  l10n.waitingPartnerAcceptRequest,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      );
    }

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
              endDrawer: ChatRoomInfoDrawer(room: widget.room),
              appBar: ChatRoomTitleBar(room: widget.room),
              bottomNavigationBar: widget.room.isArchived || widget.room.isSpace
                  ? null
                  : ChatInput(
                      key: ValueKey('${widget.room.id}input'),
                      room: widget.room,
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
      ),
    );
  }
}
