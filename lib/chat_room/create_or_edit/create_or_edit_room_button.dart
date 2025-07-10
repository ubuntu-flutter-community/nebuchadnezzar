import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../common/chat_model.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/snackbars.dart';
import '../../l10n/l10n.dart';
import '../input/draft_model.dart';
import 'create_or_edit_room_model.dart';

class CreateOrEditRoomButton extends StatelessWidget with WatchItMixin {
  const CreateOrEditRoomButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = watchPropertyValue((CreateOrEditRoomModel m) => m.name);
    final topic = watchPropertyValue((CreateOrEditRoomModel m) => m.topic);
    final space = watchPropertyValue((CreateOrEditRoomModel m) => m.isSpace);
    final profiles = watchPropertyValue(
      (CreateOrEditRoomModel m) => m.profiles,
    );
    final joinRules = watchPropertyValue(
      (CreateOrEditRoomModel m) => m.joinRules,
    );
    final historyVisibility = watchPropertyValue(
      (CreateOrEditRoomModel m) => m.historyVisibility,
    );
    final groupCall = watchPropertyValue(
      (CreateOrEditRoomModel m) => m.groupCall,
    );
    final federated = watchPropertyValue(
      (CreateOrEditRoomModel m) => m.federated,
    );
    final encrypted = watchPropertyValue(
      (CreateOrEditRoomModel m) => m.enableEncryption,
    );
    final avatarDraftFile = watchPropertyValue(
      (DraftModel m) => m.avatarDraftFile,
    );

    return ImportantButton(
      onPressed: name.trim().isEmpty
          ? null
          : () {
              if (context.mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              if (space) {
                di<ChatModel>().createSpace(
                  name: name,
                  topic: topic,
                  invite: profiles.map((p) => p.userId).toList(),
                  joinRules: joinRules,
                  onFail: (error) =>
                      showSnackBar(context, content: Text(error)),
                  onSuccess: () {
                    di<DraftModel>().resetAvatar();
                  },
                );
              } else {
                di<ChatModel>().createRoom(
                  avatarFile: avatarDraftFile,
                  enableEncryption: encrypted,
                  invite: profiles.map((p) => p.userId).toList(),
                  groupName: name,
                  joinRules: joinRules,
                  historyVisibility: historyVisibility,
                  onFail: (error) =>
                      showSnackBar(context, content: Text(error)),
                  onSuccess: () {
                    di<DraftModel>().resetAvatar();
                  },
                  groupCall: groupCall,
                  federated: federated,
                );
              }
            },
      child: Text(space ? l10n.createNewSpace : l10n.createGroup),
    );
  }
}
