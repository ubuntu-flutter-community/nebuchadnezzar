import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Visibility;
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../../common/view/build_context_x.dart';
import '../../../../common/view/common_widgets.dart';
import '../../../../common/view/sliver_sticky_panel.dart';
import '../../../../common/view/snackbars.dart';
import '../../../../common/view/space.dart';
import '../../../../common/view/ui_constants.dart';
import '../../../../l10n/l10n.dart';
import '../../../common/chat_model.dart';
import '../../input/draft_model.dart';
import '../../../common/view/chat_avatar.dart';
import '../../../common/view/search_auto_complete.dart';
import 'chat_room_create_or_edit_avatar.dart';
import 'chat_room_permissions.dart';
import 'chat_room_users_list.dart';

const _maxWidth = 500.0;

class ChatCreateOrEditRoomDialog extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatCreateOrEditRoomDialog({
    super.key,
    this.room,
    this.space = false,
  });

  final Room? room;
  final bool space;

  @override
  State<ChatCreateOrEditRoomDialog> createState() =>
      _ChatCreateOrEditRoomDialogState();
}

class _ChatCreateOrEditRoomDialogState
    extends State<ChatCreateOrEditRoomDialog> {
  late Visibility _visibility;
  Set<Profile> _profiles = {};
  late final bool _isSpace;
  String? _groupName;
  String? _topic;
  late bool _enableEncryption;
  late bool _federated;
  late bool _groupCall;

  late final bool _existingGroup;

  late final TextEditingController _groupNameController;
  late final TextEditingController _groupTopicController;

  @override
  void initState() {
    super.initState();
    _groupName = widget.room?.name;
    _isSpace = widget.room?.isSpace ?? widget.space;
    _topic = widget.room?.topic;
    _existingGroup = widget.room != null;

    _enableEncryption = widget.room?.encrypted ?? false;
    _federated = widget.room?.isFederated ?? true;
    _groupCall = widget.room?.hasActiveGroupCall ?? false;
    _groupNameController = TextEditingController(text: _groupName);
    _groupTopicController = TextEditingController(text: _topic);
    _visibility = (widget.room?.joinRules == JoinRules.public
        ? Visibility.public
        : Visibility.private);
    _profiles = widget.room
            ?.getParticipants()
            .where(
              (e) {
                final id = e.id.split(':').firstOrNull?.replaceAll('@', '');

                return id?.isNotEmpty == true;
              },
            )
            .map(
              (e) => Profile(
                userId: e.id.split(':').firstOrNull!.replaceAll('@', ''),
                avatarUrl: e.avatarUrl,
              ),
            )
            .toSet() ??
        <Profile>{};
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mediaQueryWidth = context.mediaQuerySize.width;

    final usedWidth = mediaQueryWidth > 520.0 ? _maxWidth : 280.0;
    final avatarDraftFile =
        watchPropertyValue((DraftModel m) => m.avatarDraftFile);

    final profileListView = ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: kBigPadding,
      ),
      itemCount: _profiles.length,
      itemBuilder: (context, index) {
        final t = _profiles.elementAt(index);
        return ListTile(
          shape: const RoundedRectangleBorder(),
          contentPadding: EdgeInsets.zero,
          key: ValueKey(t.userId),
          leading: ChatAvatar(avatarUri: t.avatarUrl),
          title: Text(
            t.displayName ?? t.userId,
            maxLines: 1,
          ),
          subtitle: Text(
            t.userId,
            maxLines: 1,
          ),
          trailing: t.userId == di<ChatModel>().myUserId
              ? null
              : IconButton(
                  onPressed: () => setState(() {
                    _profiles.remove(t);
                    if (_existingGroup) widget.room!.kick(t.userId);
                  }),
                  icon: const Icon(
                    YaruIcons.trash,
                  ),
                ),
        );
      },
    );

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.start,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.all(kMediumPadding),
      contentPadding: EdgeInsets.zero,
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
                      _existingGroup
                          ? '${l10n.edit} ${_isSpace ? l10n.space : l10n.group}'
                          : _isSpace
                              ? l10n.createNewSpace
                              : l10n.createGroup,
                    ),
                  ),
                ),
                if (!_isSpace)
                  SliverToBoxAdapter(
                    child: Center(
                      child: ChatRoomCreateOrEditAvatar(
                        avatarDraftBytes: avatarDraftFile?.bytes,
                        room: widget.room,
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: YaruSection(
                      headline: Text(l10n.group),
                      child: Padding(
                        padding: const EdgeInsets.all(kMediumPadding),
                        child: Column(
                          spacing: kBigPadding,
                          children: [
                            TextField(
                              autofocus: true,
                              enabled: widget.room == null ||
                                  widget.room?.canChangeStateEvent(
                                        EventTypes.RoomName,
                                      ) ==
                                      true,
                              controller: _groupNameController,
                              onChanged: (v) => setState(() {
                                _groupName = v;
                              }),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(12),
                                label: Text(
                                  _isSpace ? l10n.spaceName : l10n.groupName,
                                ),
                                suffixIcon: (_existingGroup &&
                                        widget.room!.canChangeStateEvent(
                                          EventTypes.RoomName,
                                        ))
                                    ? IconButton(
                                        padding: EdgeInsets.zero,
                                        style: IconButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                            ),
                                          ),
                                        ),
                                        onPressed:
                                            _groupName != widget.room!.name
                                                ? () => widget.room!
                                                    .setName(_groupName!)
                                                : null,
                                        icon: const Icon(YaruIcons.save),
                                      )
                                    : null,
                              ),
                            ),
                            TextField(
                              enabled: widget.room == null ||
                                  widget.room?.canChangeStateEvent(
                                        EventTypes.RoomTopic,
                                      ) ==
                                      true,
                              controller: _groupTopicController,
                              onChanged: (v) => setState(() {
                                _topic = v;
                              }),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(12),
                                label: Text(l10n.chatDescription),
                                suffixIcon: (_existingGroup &&
                                        widget.room!.canChangeStateEvent(
                                          EventTypes.RoomTopic,
                                        ))
                                    ? IconButton(
                                        padding: EdgeInsets.zero,
                                        style: IconButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                            ),
                                          ),
                                        ),
                                        onPressed: _topic != widget.room!.topic
                                            ? () => widget.room!
                                                .setDescription(_topic!)
                                            : null,
                                        icon: const Icon(YaruIcons.save),
                                      )
                                    : null,
                              ),
                            ),
                            if (!_isSpace)
                              YaruTile(
                                leading: _enableEncryption
                                    ? const Icon(YaruIcons.shield_filled)
                                    : const Icon(YaruIcons.shield),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kMediumPadding,
                                ),
                                trailing: CommonSwitch(
                                  value: _enableEncryption,
                                  onChanged: widget.room?.encrypted == true ||
                                          widget.room?.canChangeStateEvent(
                                                EventTypes.Encryption,
                                              ) ==
                                              false
                                      ? null
                                      : (v) {
                                          setState(() => _enableEncryption = v);

                                          if (_enableEncryption &&
                                              widget.room?.encrypted == false) {
                                            widget.room?.enableEncryption();
                                          }
                                        },
                                ),
                                title: Text(l10n.encrypted),
                              ),
                            if (!_existingGroup)
                              YaruTile(
                                leading: _visibility == Visibility.private
                                    ? const Icon(YaruIcons.private_mask_filled)
                                    : const Icon(YaruIcons.private_mask),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kMediumPadding,
                                ),
                                title: _visibility == Visibility.private
                                    ? Text(l10n.guestsCanJoin)
                                    : Text(l10n.anyoneCanJoin),
                                trailing: CommonSwitch(
                                  value: _visibility == Visibility.private,
                                  onChanged: widget.room?.canChangeStateEvent(
                                            EventTypes.RoomJoinRules,
                                          ) ==
                                          false
                                      ? null
                                      : (v) {
                                          if (v) {
                                            widget.room?.setJoinRules(
                                              JoinRules.public,
                                            );
                                          } else {
                                            widget.room?.setJoinRules(
                                              JoinRules.private,
                                            );
                                          }
                                          setState(
                                            () => _visibility = v
                                                ? Visibility.private
                                                : Visibility.public,
                                          );
                                        },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (_existingGroup && widget.room!.canChangePowerLevel)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kMediumPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: ChatPermissionsSettingsView(
                        room: widget.room!,
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: YaruSection(
                      headline: Text(l10n.users),
                      child: Column(
                        children: [
                          if (!_existingGroup || widget.room?.canInvite == true)
                            SizedBox(
                              height: 38,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kMediumPadding,
                                ),
                                child: ChatUserSearchAutoComplete(
                                  labelText: l10n.inviteOtherUsers,
                                  width: usedWidth - 2 * kMediumPadding,
                                  suffix: const Icon(YaruIcons.user),
                                  onProfileSelected: (p) {
                                    if (_existingGroup) {
                                      widget.room!.invite(p.userId);
                                    } else {
                                      setState(() => _profiles.add(p));
                                    }
                                  },
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 200,
                            width: _maxWidth,
                            child: _existingGroup
                                ? widget.room?.canInvite == true
                                    ? ChatRoomUsersList(
                                        room: widget.room!,
                                        sliver: false,
                                        showChatIcon: false,
                                      )
                                    : const SizedBox.shrink()
                                : profileListView,
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
      actions: _existingGroup
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
                    ImportantButton(
                      onPressed: _groupName == null ||
                              _groupName!.trim().isEmpty
                          ? null
                          : () {
                              if (context.mounted &&
                                  Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                              if (_isSpace) {
                                di<ChatModel>().createSpace(
                                  name: _groupName!,
                                  topic: _groupTopicController.text,
                                  invite:
                                      _profiles.map((p) => p.userId).toList(),
                                  visibility: _visibility,
                                  onFail: (error) => showSnackBar(
                                    context,
                                    content: Text(error),
                                  ),
                                  onSuccess: () {
                                    di<DraftModel>().resetAvatar();
                                  },
                                );
                              } else {
                                di<ChatModel>().createRoom(
                                  avatarFile: avatarDraftFile,
                                  enableEncryption: _enableEncryption,
                                  preset: CreateRoomPreset.publicChat,
                                  invite:
                                      _profiles.map((p) => p.userId).toList(),
                                  groupName: _groupName,
                                  visibility: _visibility,
                                  onFail: (error) => showSnackBar(
                                    context,
                                    content: Text(error),
                                  ),
                                  onSuccess: () {
                                    di<DraftModel>().resetAvatar();
                                  },
                                  groupCall: _groupCall,
                                  federated: _federated,
                                );
                              }
                            },
                      child: Text(
                        _isSpace ? l10n.createNewSpace : l10n.createGroup,
                      ),
                    ),
                  ],
                ),
              ),
            ],
    );
  }
}
