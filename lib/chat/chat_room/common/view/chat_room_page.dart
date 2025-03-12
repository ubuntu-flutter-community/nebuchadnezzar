import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../common/view/build_context_x.dart';
import '../../../../common/view/common_widgets.dart';
import '../../../../common/view/confirm.dart';
import '../../../../common/view/snackbars.dart';
import '../../../../common/view/ui_constants.dart';
import '../../../../l10n/l10n.dart';
import '../../../common/chat_model.dart';
import '../../input/view/chat_input.dart';
import '../../titlebar/chat_room_title_bar.dart';
import '../timeline_model.dart';
import 'chat_room_info_drawer.dart';
import 'chat_room_timeline_list.dart';

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
    _timelineFuture = widget.room.getTimeline(
      onNewEvent: () => _roomListKey.currentState?.setState(() {}),
      onChange: (i) => _roomListKey.currentState?.setState(() {}),
      onInsert: (i) => _roomListKey.currentState?.insertItem(i),
      onRemove: (i) =>
          _roomListKey.currentState?.removeItem(i, (_, __) => const ListTile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final updating = watchPropertyValue(
      (TimelineModel m) => m.getUpdatingTimeline(widget.room.id),
    );

    registerStreamHandler(
      select: (ChatModel m) => m.getLeftRoomStream(widget.room.id),
      handler: (context, leftRoomUpdate, cancel) {
        if (!di<ChatModel>().archiveActive &&
            !di<ChatModel>().loadingArchive &&
            leftRoomUpdate.hasData) {
          di<ChatModel>().leaveSelectedRoom(
            onFail: (error) => showSnackBar(
              context,
              content: Text(error),
            ),
          );
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

    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          key: chatRoomScaffoldKey,
          endDrawer: ChatRoomInfoDrawer(room: widget.room),
          appBar: ChatRoomTitleBar(room: widget.room),
          bottomNavigationBar: widget.room.isArchived
              ? null
              : ChatInput(
                  key: ValueKey('${widget.room.id}input'),
                  room: widget.room,
                ),
          body: FutureBuilder<Timeline>(
            key: ValueKey(widget.room.id),
            future: _timelineFuture,
            builder: (context, snapshot) => snapshot.hasData
                ? Padding(
                    padding: const EdgeInsets.only(bottom: kMediumPadding),
                    child: ChatRoomTimelineList(
                      timeline: snapshot.data!,
                      listKey: _roomListKey,
                    ),
                  )
                : const Center(
                    child: Progress(),
                  ),
          ),
        ),
        if (updating)
          Positioned(
            top: 4 * kBigPadding,
            child: RepaintBoundary(
              child: CircleAvatar(
                backgroundColor: colorScheme.surface,
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
    );
  }
}
