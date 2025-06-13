import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/app_config.dart';
import '../../common/view/snackbars.dart';
import '../../encryption/view/check_encryption_setup_page.dart';
import '../../l10n/l10n.dart';
import '../authentication_model.dart';
import 'chat_login_page_scaffold.dart';

class ChatMatrixIdLoginPage extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatMatrixIdLoginPage({super.key});

  @override
  State<ChatMatrixIdLoginPage> createState() => _ChatMatrixIdLoginPageState();
}

class _ChatMatrixIdLoginPageState extends State<ChatMatrixIdLoginPage> {
  final TextEditingController _homeServerController = TextEditingController(
    text: 'matrix.org',
  );
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authenticationModel = di<AuthenticationModel>();
    bool processingAccess = watchPropertyValue(
      (AuthenticationModel m) => m.processingAccess,
    );
    bool showPassword = watchPropertyValue(
      (AuthenticationModel m) => m.showPassword,
    );

    var onPressed = processingAccess
        ? null
        : () async {
            authenticationModel.toggleShowPassword(forceValue: false);
            return authenticationModel.login(
              homeServer: _homeServerController.text.trim(),
              username: _usernameController.text,
              password: _passwordController.text,
              onSuccess: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const CheckEncryptionSetupPage(),
                ),
                (route) => false,
              ),
              onFail: (e) => showSnackBar(context, content: Text(e.toString())),
            );
          };

    return ChatLoginPageScaffold(
      processingAccess: processingAccess,
      titleLabel: AppConfig.kAppTitle,
      canPop: true,
      content: [
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
        TextField(
          controller: _usernameController,
          readOnly: processingAccess,
          autocorrect: false,
          onSubmitted: (value) => onPressed?.call(),
          decoration: InputDecoration(labelText: l10n.username),
        ),
        TextField(
          controller: _passwordController,
          readOnly: processingAccess,
          autocorrect: false,
          obscureText: !showPassword,
          onSubmitted: (value) => onPressed?.call(),
          decoration: InputDecoration(
            labelText: l10n.password,
            suffixIconConstraints: const BoxConstraints(
              maxHeight: kYaruTitleBarItemHeight,
            ),
            suffixIcon: IconButton(
              isSelected: showPassword,
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
              ),
              onPressed: authenticationModel.toggleShowPassword,
              icon: Icon(showPassword ? YaruIcons.eye_filled : YaruIcons.eye),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 35,
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Text('Login'),
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
