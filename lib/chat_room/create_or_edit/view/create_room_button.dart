import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/chat_model.dart';
import '../../../common/view/common_widgets.dart';
import '../../../l10n/l10n.dart';
import '../create_or_edit_room_model.dart';

class CreateRoomButton extends StatelessWidget with WatchItMixin {
  const CreateRoomButton({super.key, required this.isSpace});

  final bool isSpace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = watchPropertyValue((CreateOrEditRoomModel m) => m.nameDraft);

    return ImportantButton(
      onPressed: name.trim().isEmpty
          ? null
          : () =>
                showFutureLoadingDialog(
                  context: context,
                  future: () => di<CreateOrEditRoomModel>().createRoomOrSpace(
                    space: isSpace,
                  ),
                ).then((result) {
                  if (result.asValue?.value != null) {
                    di<ChatModel>().setSelectedRoom(result.asValue!.value!);
                    if (context.mounted && Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                }),
      child: Text(isSpace ? l10n.createNewSpace : l10n.createGroup),
    );
  }
}
