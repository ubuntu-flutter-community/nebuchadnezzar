import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/theme.dart';
import '../../l10n/l10n.dart';
import '../settings_model.dart';
import 'chat_settings_logout_button.dart';

class ChatSettingsAccountSection extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatSettingsAccountSection({super.key});

  @override
  State<ChatSettingsAccountSection> createState() =>
      _ChatSettingsAccountSectionState();
}

class _ChatSettingsAccountSectionState
    extends State<ChatSettingsAccountSection> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    final settingsModel = di<SettingsModel>();
    settingsModel.init();
    _displayNameController =
        TextEditingController(text: settingsModel.myProfile?.displayName ?? '');
    _idController = TextEditingController(text: di<ChatModel>().myUserId);
  }

  @override
  void dispose() {
    super.dispose();
    _displayNameController.dispose();
    _idController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsModel = di<SettingsModel>();

    final profile = watchStream(
      (SettingsModel m) => m.myProfileStream,
      initialValue: settingsModel.myProfile,
      preserveState: false,
    ).data;

    return YaruSection(
      headline: Text(l10n.account),
      child: Column(
        children: [
          YaruTile(
            title: ListenableBuilder(
              listenable: _displayNameController,
              builder: (context, c) {
                return TextField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      style: textFieldSuffixStyle,
                      onPressed: profile?.displayName !=
                              _displayNameController.text
                          ? () => di<SettingsModel>().setDisplayName(
                                name: _displayNameController.text,
                                onFail: (e) => showErrorSnackBar(context, e),
                              )
                          : null,
                      icon: const Icon(YaruIcons.save),
                    ),
                    contentPadding: const EdgeInsets.all(10.5),
                    label: Text(l10n.editDisplayname),
                  ),
                );
              },
            ),
          ),
          YaruTile(
            title: TextField(
              enabled: false,
              controller: _idController,
            ),
            trailing: const ChatSettingsLogoutButton(),
          ),
        ],
      ),
    );
  }
}
