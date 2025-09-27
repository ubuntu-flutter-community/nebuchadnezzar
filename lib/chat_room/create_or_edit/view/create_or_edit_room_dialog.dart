import 'package:flutter/material.dart' hide Visibility;
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/sliver_sticky_panel.dart';
import '../../../common/view/space.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../../common/view/chat_room_users_list.dart';
import '../create_room_manager.dart';
import 'chat_room_permissions.dart';
import 'create_or_edit_room_avatar.dart';
import 'create_or_edit_room_header.dart';
import 'create_or_edit_room_user_search_auto_complete.dart';
import 'create_room_button.dart';
import 'create_room_profiles_list_view.dart';

const _maxWidth = 500.0;

class CreateOrEditRoomDialog extends StatefulWidget {
  const CreateOrEditRoomDialog({super.key, this.room, this.space = false});

  final Room? room;
  final bool space;

  @override
  State<CreateOrEditRoomDialog> createState() => _CreateOrEditRoomDialogState();
}

class _CreateOrEditRoomDialogState extends State<CreateOrEditRoomDialog> {
  @override
  void initState() {
    super.initState();
    di<CreateRoomManager>().init(room: widget.room);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mediaQueryWidth = context.mediaQuerySize.width;

    final usedWidth = mediaQueryWidth > 520.0 ? _maxWidth : 280.0;

    final isSpace = widget.room?.isSpace ?? widget.space;

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.start,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.all(kMediumPadding),
      contentPadding: const EdgeInsets.only(bottom: kBigPadding),
      content: SizedBox(
        height: isSpace ? _maxWidth : 2 * _maxWidth,
        width: _maxWidth,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(kYaruContainerRadius),
            topRight: Radius.circular(kYaruContainerRadius),
          ),
          child: CustomScrollView(
            slivers: space(
              sliver: true,
              heightGap: kBigPadding,
              children: [
                SliverStickyPanel(
                  backgroundColor: context.theme.dialogTheme.backgroundColor,
                  padding: EdgeInsets.zero,
                  child: YaruDialogTitleBar(
                    backgroundColor: Colors.transparent,
                    border: BorderSide.none,
                    title: Text(
                      widget.room != null
                          ? '${l10n.edit} ${isSpace ? l10n.space : l10n.group}'
                          : isSpace
                          ? l10n.createNewSpace
                          : l10n.createGroup,
                    ),
                  ),
                ),
                if (!isSpace)
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: kBigPadding),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: CreateOrEditRoomAvatar(room: widget.room),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: kBigPadding),
                  sliver: SliverToBoxAdapter(
                    child: CreateOrEditRoomHeader(
                      room: widget.room,
                      isSpace: isSpace,
                    ),
                  ),
                ),
                if (widget.room != null && !isSpace)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kBigPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: ChatRoomPermissions(room: widget.room!),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: kBigPadding),
                  sliver: SliverToBoxAdapter(
                    child: YaruSection(
                      headline: Text(l10n.users),
                      child: Column(
                        children: [
                          if (widget.room == null ||
                              widget.room?.canInvite == true)
                            CreateOrEditRoomUserSearchAutoComplete(
                              room: widget.room,
                              useWidth: usedWidth,
                            ),
                          SizedBox(
                            height: 200,
                            width: _maxWidth,
                            child: widget.room != null
                                ? widget.room?.canInvite == true
                                      ? ChatRoomUsersList(
                                          room: widget.room!,
                                          sliver: false,
                                        )
                                      : const SizedBox.shrink()
                                : const CreateRoomProfilesListView(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: widget.room != null
          ? null
          : [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: space(
                  expand: true,
                  widthGap: kMediumPadding,
                  children: [
                    OutlinedButton(
                      onPressed: Navigator.of(context).pop,
                      child: Text(l10n.cancel),
                    ),
                    CreateRoomButton(isSpace: isSpace),
                  ],
                ),
              ),
            ],
    );
  }
}
