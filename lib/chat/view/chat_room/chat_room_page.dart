import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/common_widgets.dart';
import '../../../common/view/confirm.dart';
import '../../../common/view/snackbars.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../chat_model.dart';
import '../../timeline_model.dart';
import 'chat_room_default_background.dart';
import 'chat_room_info_drawer.dart';
import 'chat_room_timeline_list.dart';
import 'input/chat_input.dart';
import 'titlebar/chat_room_title_bar.dart';

final GlobalKey<ScaffoldState> chatRoomScaffoldKey = GlobalKey();

class ChatRoomPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  final Room room;
  const ChatRoomPage({required this.room, super.key});

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
      onUpdate: () => _roomListKey.currentState?.setState(() {}),
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
    final archiveActive = watchPropertyValue((ChatModel m) => m.archiveActive);
    final loadingArchive =
        watchPropertyValue((ChatModel m) => m.loadingArchive);
    final updating =
        watchPropertyValue((TimelineModel m) => m.updatingTimeline);

    registerStreamHandler(
      select: (ChatModel m) => m.getLeftRoomStream(widget.room.id),
      handler: (context, leftRoomUpdate, cancel) {
        if (!archiveActive && !loadingArchive && leftRoomUpdate.hasData) {
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
        const ChatRoomDefaultBackground(),
        Scaffold(
          key: chatRoomScaffoldKey,
          endDrawer: ChatRoomInfoDrawer(room: widget.room),
          backgroundColor: Colors.transparent,
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
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Progress(),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: kMediumPadding),
                child: ChatRoomTimelineList(
                  timeline: snapshot.data!,
                  room: widget.room,
                  listKey: _roomListKey,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 3 * kBigPadding,
          child: IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: updating ? 1 : 0,
              child: FloatingActionButton.small(
                backgroundColor: context.colorScheme.isLight
                    ? Colors.white
                    : Colors.black.scale(lightness: 0.09),
                onPressed: () {},
                child: const SizedBox.square(
                  dimension: 20,
                  child: Progress(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
