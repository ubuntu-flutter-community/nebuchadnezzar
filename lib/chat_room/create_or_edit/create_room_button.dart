import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/chat_model.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/snackbars.dart';
import '../../l10n/l10n.dart';
import 'create_or_edit_room_model.dart';

class CreateRoomButton extends StatelessWidget with WatchItMixin {
  const CreateRoomButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = watchPropertyValue((CreateOrEditRoomModel m) => m.nameDraft);
    final topic = watchPropertyValue((CreateOrEditRoomModel m) => m.topicDraft);
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
      (CreateOrEditRoomModel m) => m.avatarDraftFile,
    );

    return ImportantButton(
      onPressed: name.trim().isEmpty
          ? null
          : () async {
              if (context.mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }

              final result = await showFutureLoadingDialog(
                context: context,
                onError: (error) {
                  showErrorSnackBar(context, error.toString());
                  return error.toString();
                },
                future: () => di<ChatModel>().createRoomOrSpace(
                  space: space,
                  spaceTopic: topic,
                  avatarFile: avatarDraftFile,
                  enableEncryption: encrypted,
                  invite: profiles.map((p) => p.userId).toList(),
                  groupName: name,
                  joinRules: joinRules,
                  historyVisibility: historyVisibility,

                  groupCall: groupCall,
                  federated: federated,
                ),
              );

              if (result.asValue?.value != null) {
                di<ChatModel>().setSelectedRoom(result.asValue!.value!);
              }
            },
      child: Text(space ? l10n.createNewSpace : l10n.createGroup),
    );
  }
}
