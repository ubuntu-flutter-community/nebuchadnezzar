import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Visibility;
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../../common/view/build_context_x.dart';
import '../../../../common/view/common_widgets.dart';
import '../../../../common/view/snackbars.dart';
import '../../../../common/view/space.dart';
import '../../../../common/view/ui_constants.dart';
import '../../../../l10n/l10n.dart';
import '../../../common/chat_model.dart';
import '../../input/draft_model.dart';
import '../../../common/view/chat_avatar.dart';
import '../../../common/view/search_auto_complete.dart';
import 'chat_room_create_or_edit_avatar.dart';
import 'chat_room_users_list.dart';

const _maxWidth = 400.0;

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
    final twoPaneMode = mediaQueryWidth > 1200;

    final usedWidth = mediaQueryWidth > 520.0 ? _maxWidth : 280.0;
    final avatarDraftFile =
        watchPropertyValue((DraftModel m) => m.avatarDraftFile);

    final profileListView = ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: twoPaneMode ? 0 : kBigPadding,
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

    final userSearchField = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
      ),
      child: ChatUserSearchAutoComplete(
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
    );

    final leftColumn = Column(
      mainAxisSize: MainAxisSize.min,
      spacing: kBigPadding,
      children: [
        if (!_isSpace)
          ChatRoomCreateOrEditAvatar(
            avatarDraftBytes: avatarDraftFile?.bytes,
            room: widget.room,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kMediumPadding,
          ),
          child: TextField(
            autofocus: true,
            enabled: widget.room == null ||
                widget.room?.canChangeStateEvent(EventTypes.RoomName) == true,
            controller: _groupNameController,
            onChanged: (v) => setState(() {
              _groupName = v;
            }),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              label: Text(_isSpace ? l10n.spaceName : l10n.groupName),
              suffixIcon: (_existingGroup &&
                      widget.room!.canChangeStateEvent(EventTypes.RoomName))
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
                      onPressed: _groupName != widget.room!.name
                          ? () => widget.room!.setName(_groupName!)
                          : null,
                      icon: const Icon(YaruIcons.save),
                    )
                  : null,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kMediumPadding,
          ),
          child: TextField(
            enabled: widget.room == null ||
                widget.room?.canChangeStateEvent(EventTypes.RoomTopic) == true,
            controller: _groupTopicController,
            onChanged: (v) => setState(() {
              _topic = v;
            }),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              label: Text(l10n.chatDescription),
              suffixIcon: (_existingGroup &&
                      widget.room!.canChangeStateEvent(EventTypes.RoomTopic))
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
                          ? () => widget.room!.setDescription(_topic!)
                          : null,
                      icon: const Icon(YaruIcons.save),
                    )
                  : null,
            ),
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
                      widget.room?.canChangeStateEvent(EventTypes.Encryption) ==
                          false
                  ? null
                  : (v) {
                      if (widget.room != null) {
                        widget.room!.enableEncryption();
                      }

                      setState(() => _enableEncryption = v);
                    },
            ),
            title: Text(l10n.encrypted),
            subtitle: widget.room?.encrypted == true
                ? null
                : (Text(l10n.enableEncryptionWarning)),
          ),
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
            onChanged:
                widget.room?.canChangeStateEvent(EventTypes.RoomJoinRules) ==
                        false
                    ? null
                    : (v) {
                        if (v) {
                          widget.room?.setJoinRules(JoinRules.public);
                        } else {
                          widget.room?.setJoinRules(JoinRules.private);
                        }
                        setState(
                          () => _visibility =
                              v ? Visibility.private : Visibility.public,
                        );
                      },
          ),
        ),
        if (!twoPaneMode) userSearchField,
        if (!twoPaneMode)
          Expanded(
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
    );

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: YaruDialogTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
        title: Text(
          _existingGroup
              ? '${l10n.edit} ${_isSpace ? l10n.space : l10n.group}'
              : _isSpace
                  ? l10n.createNewSpace
                  : l10n.createGroup,
        ),
      ),
      actionsAlignment: MainAxisAlignment.start,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.all(kMediumPadding),
      contentPadding: const EdgeInsets.all(kMediumPadding),
      content: SizedBox(
        height: 2 * _maxWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: usedWidth,
              child: leftColumn,
            ),
            if (twoPaneMode)
              const Padding(
                padding: EdgeInsets.all(kMediumPadding),
                child: VerticalDivider(
                  width: 0.1,
                  thickness: 0.5,
                ),
              ),
            if (twoPaneMode)
              SizedBox(
                width: usedWidth,
                child: Column(
                  spacing: kMediumPadding,
                  children: [
                    userSearchField,
                    Expanded(
                      child: _profiles.isEmpty
                          ? const Center(
                              child: Icon(
                                YaruIcons.users,
                                size: 100,
                              ),
                            )
                          : _existingGroup
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
          ],
        ),
      ),
      scrollable: true,
      actions: _existingGroup
          ? null
          : [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: space(
                  expand: !twoPaneMode,
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
