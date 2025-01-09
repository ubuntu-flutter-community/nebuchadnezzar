import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../chat_model.dart';
import '../view/chat_master/chat_my_user_avatar.dart';
import 'logout_button.dart';
import 'settings_model.dart';

class SettingsDialog extends StatefulWidget with WatchItStatefulWidgetMixin {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _idController = TextEditingController(text: di<ChatModel>().myUserId);
    di<SettingsModel>().getMyProfile().then((v) {
      _displayNameController.text = v?.displayName ?? '';
      _idController.text = v?.userId ?? '';
    });
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
    watchFuture(
      (SettingsModel m) => m.getMyProfile(),
      initialValue: di<SettingsModel>().myProfile,
      preserveState: false,
    );
    final profile = watchStream(
      (SettingsModel m) => m.myProfileStream,
      initialValue: di<SettingsModel>().myProfile,
      preserveState: false,
    ).data;

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: YaruDialogTitleBar(
        title: Text(l10n.settings),
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      scrollable: true,
      content: SizedBox(
        height: 800,
        width: 500,
        child: Column(
          spacing: 2 * kBigPadding,
          children: [
            ChatMyUserAvatar(
              key: ValueKey(profile?.avatarUrl),
              uri: profile?.avatarUrl,
              dimension: 100,
              iconSize: 70,
            ),
            YaruSection(
              child: Column(
                children: [
                  YaruTile(
                    title: TextField(
                      controller: _displayNameController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          style: IconButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                            ),
                          ),
                          onPressed: profile?.displayName !=
                                  _displayNameController.text
                              ? () => di<SettingsModel>().setDisplayName(
                                    name: _displayNameController.text,
                                    onFail: (e) =>
                                        showErrorSnackBar(context, e),
                                  )
                              : null,
                          icon: const Icon(YaruIcons.save),
                        ),
                        contentPadding: const EdgeInsets.all(10.5),
                        label: Text(l10n.editDisplayname),
                      ),
                    ),
                  ),
                  YaruTile(
                    title: TextField(
                      enabled: false,
                      controller: _idController,
                    ),
                    trailing: const LogoutButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
