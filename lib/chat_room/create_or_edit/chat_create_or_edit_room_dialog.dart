import 'package:flutter/material.dart' hide Visibility;
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/search_auto_complete.dart';
import '../../common/view/sliver_sticky_panel.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/space.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../common/view/chat_room_users_list.dart';
import '../input/draft_model.dart';
import 'chat_room_create_or_edit_avatar.dart';
import 'chat_room_permissions.dart';
import 'create_or_edit_room_button.dart';
import 'create_or_edit_room_header.dart';
import 'create_or_edit_room_model.dart';
import 'profiles_list_view.dart';

const _maxWidth = 500.0;

class ChatCreateOrEditRoomDialog extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatCreateOrEditRoomDialog({super.key, this.room, this.space = false});

  final Room? room;
  final bool space;

  @override
  State<ChatCreateOrEditRoomDialog> createState() =>
      _ChatCreateOrEditRoomDialogState();
}

class _ChatCreateOrEditRoomDialogState
    extends State<ChatCreateOrEditRoomDialog> {
  @override
  void initState() {
    super.initState();
    di<CreateOrEditRoomModel>().loadFromDialog(
      room: widget.room,
      isSpace: widget.space,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mediaQueryWidth = context.mediaQuerySize.width;

    final usedWidth = mediaQueryWidth > 520.0 ? _maxWidth : 280.0;
    final avatarDraftFile = watchPropertyValue(
      (DraftModel m) => m.avatarDraftFile,
    );

    final isSpace = widget.room?.isSpace ?? widget.space;

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.start,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.all(kMediumPadding),
      contentPadding: const EdgeInsets.only(bottom: kBigPadding),
      content: SizedBox(
        height: 2 * _maxWidth,
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
                        child: ChatRoomCreateOrEditAvatar(
                          avatarDraftBytes: avatarDraftFile?.bytes,
                          room: widget.room,
                        ),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: kBigPadding),
                  sliver: SliverToBoxAdapter(
                    child: CreateOrEditRoomHeader(room: widget.room),
                  ),
                ),
                if (widget.room != null)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kBigPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: ChatPermissionsSettingsView(room: widget.room!),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kMediumPadding,
                                vertical: kSmallPadding,
                              ),
                              child: SizedBox(
                                height: 38,
                                child: ChatUserSearchAutoComplete(
                                  labelText: l10n.inviteOtherUsers,
                                  width: usedWidth - 2 * kMediumPadding,
                                  suffix: const Icon(YaruIcons.user),
                                  onProfileSelected: (p) {
                                    if (widget.room != null) {
                                      showFutureLoadingDialog(
                                        context: context,
                                        future: () =>
                                            di<CreateOrEditRoomModel>()
                                                .inviteUserToRoom(
                                                  room: widget.room!,
                                                  userId: p.userId,
                                                ),
                                        onError: (e) {
                                          showErrorSnackBar(context, e);
                                          return e;
                                        },
                                      );
                                    } else {
                                      di<CreateOrEditRoomModel>().addProfile(p);
                                    }
                                  },
                                ),
                              ),
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
                                : const ProfilesListView(),
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
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                    const CreateOrEditRoomButton(),
                  ],
                ),
              ),
            ],
    );
  }
}
