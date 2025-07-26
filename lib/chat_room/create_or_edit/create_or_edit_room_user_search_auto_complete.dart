import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/chat_user_search_auto_complete.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import 'create_or_edit_room_model.dart';

class CreateOrEditRoomUserSearchAutoComplete extends StatelessWidget {
  const CreateOrEditRoomUserSearchAutoComplete({
    super.key,
    this.room,
    required this.useWidth,
  });

  final Room? room;
  final double useWidth;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kMediumPadding,
      vertical: kSmallPadding,
    ),
    child: SizedBox(
      height: 38,
      child: ChatUserSearchAutoComplete(
        labelText: context.l10n.inviteOtherUsers,
        width: useWidth - 2 * kMediumPadding,
        suffix: const Icon(YaruIcons.user),
        onProfileSelected: (p) {
          if (room != null) {
            showFutureLoadingDialog(
              context: context,
              future: () => di<CreateOrEditRoomModel>().inviteUserToRoom(
                room: room!,
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
  );
}
