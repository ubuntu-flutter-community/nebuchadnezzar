import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/app_config.dart';
import '../../common/constants.dart';
import '../../common/view/theme.dart';
import '../../encryption/view/check_encryption_setup_page.dart';
import '../../l10n/l10n.dart';
import '../authentication_capsule.dart';
import '../authentication_manager.dart';
import 'chat_login_page_scaffold.dart';

class ChatMatrixIdLoginPage extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatMatrixIdLoginPage({super.key});

  @override
  State<ChatMatrixIdLoginPage> createState() => _ChatMatrixIdLoginPageState();
}

class _ChatMatrixIdLoginPageState extends State<ChatMatrixIdLoginPage> {
  final TextEditingController _homeServerController = TextEditingController(
    text: defaultHomeServer,
  );
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> onPressed(BuildContext context) async =>
      di<AuthenticationManager>().loginCommand.run(
        LoginCapsule(
          loginMethod: LoginType.mLoginPassword,
          homeServer: _homeServerController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final processingAccess = watchValue(
      (AuthenticationManager s) => s.loginCommand.isRunning,
    );

    final errors = watchValue(
      (AuthenticationManager s) => s.loginCommand.errors,
    );

    final showPassword = watchValue(
      (AuthenticationManager s) => s.showPassword,
    );

    registerHandler(
      select: (AuthenticationManager m) => m.loginCommand,
      handler: (context, userId, cancel) {
        if (userId != null && context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const CheckEncryptionSetupPage()),
            (route) => false,
          );
        }
      },
    );

    return ChatLoginPageScaffold(
      processingAccess: processingAccess,
      titleLabel: AppConfig.kAppTitle,
      canPop: true,
      content: [
        TextField(
          controller: _homeServerController,
          readOnly: processingAccess,
          autocorrect: false,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            error: errors?.error != null
                ? Row(
                    children: [
                      const Icon(Icons.error),
                      const SizedBox(width: 8),
                      Expanded(child: Text(errors!.error.toString())),
                    ],
                  )
                : null,
            prefixText: 'https://',
            labelText: l10n.homeserver,
          ),
        ),
        TextField(
          autofocus: true,
          controller: _usernameController,
          readOnly: processingAccess,
          autocorrect: false,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: l10n.username),
        ),
        TextField(
          controller: _passwordController,
          readOnly: processingAccess,
          autocorrect: false,
          obscureText: !showPassword,
          onSubmitted: processingAccess ? null : (value) => onPressed(context),
          decoration: InputDecoration(
            labelText: l10n.password,
            suffixIconConstraints: const BoxConstraints(
              maxHeight: kYaruTitleBarItemHeight,
            ),
            suffixIcon: IconButton(
              isSelected: showPassword,
              padding: EdgeInsets.zero,
              style: textFieldSuffixStyle,
              onPressed: () => di<AuthenticationManager>().toggleShowPassword(),
              icon: Icon(showPassword ? YaruIcons.eye_filled : YaruIcons.eye),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 35,
          child: ElevatedButton(
            onPressed: processingAccess ? null : () => onPressed(context),
            child: Text(l10n.login),
          ),
        ),
        const SizedBox(height: kYaruTitleBarHeight),
      ],
    );
  }

  @override
  void dispose() {
    _homeServerController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
