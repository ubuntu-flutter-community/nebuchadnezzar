import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../encryption_manager.dart';

class InitCryptoIdentityConfirmationDialog extends StatefulWidget {
  const InitCryptoIdentityConfirmationDialog({super.key, required this.title});

  final String title;

  @override
  State<InitCryptoIdentityConfirmationDialog> createState() =>
      _InitCryptoIdentityConfirmationDialogState();
}

class _InitCryptoIdentityConfirmationDialogState
    extends State<InitCryptoIdentityConfirmationDialog> {
  final TextEditingController _passPhraseController = TextEditingController();

  bool _wipeSecureStorage = true;
  bool _wipeKeyBackup = true;
  bool _wipeCrossSigning = true;
  bool _setupMasterKey = true;
  bool _setupSelfSigningKey = true;
  bool _setupUserSigningKey = true;
  bool _setupOnlineKeyBackup = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    var roundedRectangleBorder = const RoundedRectangleBorder();
    return ConfirmationDialog(
      title: Text(widget.title),
      content: Column(
        spacing: kMediumPadding,
        mainAxisSize: .min,
        children: [
          Text(
            l10n.resetRecoveryKeyDescription,
            style: context.theme.textTheme.titleMedium,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 1800),
            child: SingleChildScrollView(
              child: Column(
                spacing: kMediumPadding,
                children: [
                  YaruInfoBox(
                    yaruInfoType: YaruInfoType.information,
                    subtitle: Text(
                      l10n.yourPassphraseDescription,
                      style: context.theme.textTheme.labelMedium,
                      maxLines: 4,
                    ),
                  ),
                  TextField(
                    controller: _passPhraseController,
                    decoration: InputDecoration(labelText: l10n.yourPassphrase),
                  ),
                  YaruExpandable(
                    header: Text(l10n.showAddtionalNewCryptoSetupOptions),
                    child: Column(
                      spacing: kMediumPadding,
                      children: [
                        YaruInfoBox(
                          yaruInfoType: YaruInfoType.danger,
                          subtitle: Text(
                            l10n.showAddtionalNewCryptoSetupOptionsWarning,
                          ),
                        ),
                        YaruBorderContainer(
                          child: SizedBox(
                            height: 200,
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: kMediumPadding,
                                children: [
                                  YaruCheckboxListTile(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(
                                          kYaruContainerRadius,
                                        ),
                                      ),
                                    ),
                                    value: _wipeSecureStorage,
                                    onChanged: (value) => setState(
                                      () => _wipeSecureStorage = value ?? false,
                                    ),
                                    title: Text(l10n.wipeSecureStorage),
                                  ),
                                  YaruCheckboxListTile(
                                    shape: roundedRectangleBorder,
                                    value: _wipeKeyBackup,
                                    onChanged: (value) => setState(
                                      () => _wipeKeyBackup = value ?? false,
                                    ),
                                    title: Text(l10n.wipeKeyBackup),
                                  ),
                                  YaruCheckboxListTile(
                                    shape: roundedRectangleBorder,
                                    value: _wipeCrossSigning,
                                    onChanged: (value) => setState(
                                      () => _wipeCrossSigning = value ?? false,
                                    ),
                                    title: Text(l10n.wipeCrossSigning),
                                  ),
                                  YaruCheckboxListTile(
                                    shape: roundedRectangleBorder,
                                    value: _setupMasterKey,
                                    onChanged: (value) => setState(
                                      () => _setupMasterKey = value ?? false,
                                    ),
                                    title: Text(l10n.setupMasterKey),
                                  ),
                                  YaruCheckboxListTile(
                                    shape: roundedRectangleBorder,
                                    value: _setupSelfSigningKey,
                                    onChanged: (value) => setState(
                                      () =>
                                          _setupSelfSigningKey = value ?? false,
                                    ),
                                    title: Text(l10n.setupSelfSigningKey),
                                  ),
                                  YaruCheckboxListTile(
                                    shape: roundedRectangleBorder,
                                    value: _setupUserSigningKey,
                                    onChanged: (value) => setState(
                                      () =>
                                          _setupUserSigningKey = value ?? false,
                                    ),
                                    title: Text(l10n.setupUserSigningKey),
                                  ),
                                  YaruCheckboxListTile(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(
                                          kYaruContainerRadius,
                                        ),
                                      ),
                                    ),
                                    value: _setupOnlineKeyBackup,
                                    onChanged: (value) => setState(
                                      () => _setupOnlineKeyBackup =
                                          value ?? false,
                                    ),
                                    title: Text(l10n.setupOnlineKeyBackup),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      confirmLabel: l10n.resetRecoveryKeyConfirmationLabel,
      onConfirm: () => di<EncryptionManager>().initCryptoIdentityCommand.run(),
    );
  }
}
