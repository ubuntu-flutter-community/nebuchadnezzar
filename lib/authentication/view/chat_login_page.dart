import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/app_config.dart';
import '../../common/constants.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../authentication_manager.dart';
import 'authentication_mixin.dart';
import 'chat_login_page_scaffold.dart';
import 'chat_matrix_id_login_page.dart';

class ChatLoginPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatLoginPage({super.key});

  @override
  State<ChatLoginPage> createState() => _ChatLoginPageState();
}

class _ChatLoginPageState extends State<ChatLoginPage>
    with AuthenticationMixin {
  final TextEditingController _homeServerController = TextEditingController(
    text: defaultHomeServer,
  );

  Future<void> onPressed(BuildContext context) async => login(
    context,
    loginMethod: LoginType.mLoginToken,
    homeServer: _homeServerController.text.trim(),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final readOnly = watchValue(
      (AuthenticationManager s) => s.processingAccess,
    );

    return ChatLoginPageScaffold(
      processingAccess: readOnly,
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
          readOnly: readOnly,
          autocorrect: false,
          onSubmitted: readOnly ? null : (value) => onPressed(context),
          decoration: InputDecoration(
            prefixText: 'https://',
            labelText: l10n.homeserver,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            iconAlignment: IconAlignment.start,
            onPressed: readOnly ? null : () => onPressed(context),
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
            onPressed: readOnly
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
