import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/create_or_edit/create_or_edit_room_model.dart';
import '../../chat_room/titlebar/chat_room_notification_button.dart';
import '../../common/chat_model.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../l10n/l10n.dart';
import 'add_and_remove_from_space_dialog.dart';

class ChatMasterTileMenu extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatMasterTileMenu({
    super.key,
    required this.room,
    required this.child,
  });

  final Room room;
  final Widget child;

  @override
  State<ChatMasterTileMenu> createState() => _ChatMasterTileMenuState();
}

class _ChatMasterTileMenuState extends State<ChatMasterTileMenu> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    void onTap() =>
        _controller.isOpen ? _controller.close() : _controller.open();
    return GestureDetector(
      onSecondaryTap: onTap,
      onLongPress: onTap,

      child: MenuAnchor(
        controller: _controller,
        alignmentOffset: const Offset(100, -10),
        menuChildren: widget.room.isArchived
            ? []
            : [
                MenuItemButton(
                  onPressed: () => showFutureLoadingDialog(
                    context: context,
                    future: () =>
                        di<CreateOrEditRoomModel>().toggleFavorite(widget.room),
                  ),
                  leadingIcon: const Icon(YaruIcons.pin),
                  child: Text(
                    context.l10n.toggleFavorite,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                MenuItemButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) =>
                        ChatRoomNotificationsDialog(room: widget.room),
                  ),
                  leadingIcon: const Icon(YaruIcons.notification),
                  child: Text(
                    context.l10n.notifications,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                MenuItemButton(
                  onPressed: () => ConfirmationDialog.show(
                    context: context,
                    title: Text(
                      '${context.l10n.leave} ${widget.room.getLocalizedDisplayname()}',
                    ),
                    onConfirm: () =>
                        showFutureLoadingDialog(
                          context: context,
                          future: () => di<CreateOrEditRoomModel>().leaveRoom(
                            room: widget.room,
                            forget: false,
                          ),
                        ).then((_) {
                          if (mounted) {
                            di<ChatModel>().setSelectedRoom(null);
                          }
                        }),
                  ),
                  leadingIcon: const Icon(YaruIcons.log_out),
                  child: Text(
                    context.l10n.leave,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                ...[
                  MenuItemButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AddToSpaceDialog(room: widget.room),
                    ),
                    leadingIcon: const Icon(YaruIcons.plus),
                    child: Text(context.l10n.addToSpace),
                  ),

                  MenuItemButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) =>
                          RemoveFromSpaceDialog(room: widget.room),
                    ),
                    leadingIcon: const Icon(YaruIcons.minus),
                    child: Text(context.l10n.removeFromSpace),
                  ),
                ],
              ],
        child: widget.child,
      ),
    );
  }
}
