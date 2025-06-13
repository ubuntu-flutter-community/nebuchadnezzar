import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/app_config.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../encryption/view/check_encryption_setup_page.dart';
import '../../l10n/l10n.dart';
import '../authentication_model.dart';
import 'chat_login_page_scaffold.dart';
import 'chat_matrix_id_login_page.dart';

class ChatLoginPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatLoginPage({super.key});

  @override
  State<ChatLoginPage> createState() => _ChatLoginPageState();
}

class _ChatLoginPageState extends State<ChatLoginPage> {
  final TextEditingController _homeServerController = TextEditingController(
    text: 'matrix.org',
  );
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    bool processingAccess = watchPropertyValue(
      (AuthenticationModel m) => m.processingAccess,
    );

    var onPressed = processingAccess
        ? null
        : () => di<AuthenticationModel>().singleSingOnLogin(
            onSuccess: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const CheckEncryptionSetupPage(),
              ),
              (route) => false,
            ),
            onFail: (e) => showSnackBar(context, content: Text(e.toString())),
            homeServer: _homeServerController.text.trim(),
          );

    return ChatLoginPageScaffold(
      processingAccess: processingAccess,
      titleLabel: '',
      canPop: false,
      content: [
        Text(AppConfig.kAppTitle, style: context.theme.textTheme.headlineLarge),
        Padding(
          padding: const EdgeInsets.only(
            top: kMediumPadding,
            bottom: 2 * kBigPadding,
          ),
          child: Image.asset(
            'assets/nebuchadnezzar.png',
            width: 100,
            height: 100,
          ),
        ),
        TextField(
          controller: _homeServerController,
          readOnly: processingAccess,
          autocorrect: false,
          onSubmitted: (value) => onPressed?.call(),
          decoration: InputDecoration(
            prefixText: 'https://',
            labelText: l10n.homeserver,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            iconAlignment: IconAlignment.start,
            onPressed: onPressed,
            icon: const Icon(YaruIcons.globe),
            label: Text(l10n.login),
          ),
        ),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(padding: const EdgeInsets.all(12.0), child: Text(l10n.or)),
            const Expanded(child: Divider()),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: processingAccess
                ? null
                : () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ChatMatrixIdLoginPage(),
                    ),
                  ),
            label: Text(l10n.loginWithMatrixId),
          ),
        ),
      ],
    );
  }
}
