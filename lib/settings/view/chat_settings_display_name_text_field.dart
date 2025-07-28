import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix_api_lite/generated/model.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../l10n/l10n.dart';
import '../account_model.dart';

class ChatSettingsDisplayNameTextField extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatSettingsDisplayNameTextField({super.key, required this.profile});

  final Profile? profile;

  @override
  State<ChatSettingsDisplayNameTextField> createState() =>
      _ChatSettingsDisplayNameTextFieldState();
}

class _ChatSettingsDisplayNameTextFieldState
    extends State<ChatSettingsDisplayNameTextField> {
  late TextEditingController _displayNameController;
  late String _initialDisplayName;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.profile?.displayName,
    );
    _initialDisplayName = widget.profile?.displayName ?? '';
  }

  @override
  void didUpdateWidget(covariant ChatSettingsDisplayNameTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile?.displayName != widget.profile?.displayName) {
      _displayNameController.text = widget.profile?.displayName ?? '';
      _initialDisplayName = widget.profile?.displayName ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _displayNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayName =
        (watchStream((AccountModel m) => m.myProfileStream).data ??
                widget.profile)
            ?.displayName;

    return ListenableBuilder(
      listenable: _displayNameController,
      builder: (context, _) {
        final isSynced = _displayNameController.text == displayName;
        final draftWasChanged =
            _initialDisplayName != _displayNameController.text;

        return TextField(
          controller: _displayNameController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              style: textFieldSuffixStyle,
              onPressed: isSynced
                  ? null
                  : () => showFutureLoadingDialog(
                      context: context,
                      future: () => di<AccountModel>().setDisplayName(
                        name: _displayNameController.text,
                      ),
                    ),
              icon: isSynced
                  ? YaruAnimatedVectorIcon(
                      YaruAnimatedIcons.ok_filled,
                      color: draftWasChanged
                          ? context.colorScheme.success
                          : null,
                    )
                  : const Icon(YaruIcons.save),
            ),
            contentPadding: const EdgeInsets.all(10.5),
            label: Text(context.l10n.editDisplayname),
          ),
        );
      },
    );
  }
}
