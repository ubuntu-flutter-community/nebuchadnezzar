import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/chat_user_search_auto_complete.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../common/chat_model.dart';

class CreateDirectChatDialog extends StatefulWidget {
  const CreateDirectChatDialog({super.key});

  @override
  State<CreateDirectChatDialog> createState() => _CreateDirectChatDialogState();
}

class _CreateDirectChatDialogState extends State<CreateDirectChatDialog> {
  String? _error;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConfirmationDialog(
      scrollable: true,
      onConfirm: () =>
          showFutureLoadingDialog(
            context: context,
            onError: (error) {
              showErrorSnackBar(context, error.toString());
              return error.toString();
            },
            future: () =>
                di<ChatModel>().startOrGetDirectChat(_searchController.text),
          ).then((result) {
            if (result.asValue?.value != null) {
              di<ChatModel>().setSelectedRoom(result.asValue!.value!);
            }
          }),
      confirmLabel: l10n.startConversation,
      title: Text(l10n.directChat),
      content: Column(
        spacing: kBigPadding,
        children: [
          TextField(
            autofocus: true,
            controller: _searchController,
            decoration: InputDecoration(
              label: Text(
                '@${l10n.username.toLowerCase()}:${l10n.homeserver.toLowerCase()}',
              ),
              suffixIcon: const Icon(YaruIcons.user),
            ),
          ),
          ChatUserSearchAutoComplete(
            labelText: '${l10n.search} ${di<ChatModel>().homeServerId}',
            suffix: const Icon(YaruIcons.search),
            onProfileSelected: (p) => _searchController.text = p.userId,
          ),
          if (_error?.isNotEmpty ?? false)
            Text(_error!, style: TextStyle(color: context.colorScheme.error)),
        ],
      ),
    );
  }
}
