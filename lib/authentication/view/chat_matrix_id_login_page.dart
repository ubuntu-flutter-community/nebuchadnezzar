import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/space.dart';
import '../../common/view/ui_constants.dart';
import '../../app/app_config.dart';
import '../../l10n/l10n.dart';
import 'bootstrap_page.dart';
import '../authentication_model.dart';

class ChatMatrixIdLoginPage extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatMatrixIdLoginPage({super.key});

  @override
  State<ChatMatrixIdLoginPage> createState() => _ChatMatrixIdLoginPageState();
}

class _ChatMatrixIdLoginPageState extends State<ChatMatrixIdLoginPage> {
  final TextEditingController _homeServerController =
      TextEditingController(text: 'matrix.org');
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authenticationModel = di<AuthenticationModel>();
    bool processingAccess =
        watchPropertyValue((AuthenticationModel m) => m.processingAccess);
    bool showPassword =
        watchPropertyValue((AuthenticationModel m) => m.showPassword);

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
                  builder: (_) => const CheckBootstrapPage(),
                ),
                (route) => false,
              ),
              onFail: (e) => showSnackBar(context, content: Text(e.toString())),
            );
          };

    return Scaffold(
      appBar: YaruWindowTitleBar(
        leading: processingAccess
            ? null
            : const YaruBackButton(style: YaruBackButtonStyle.rounded),
        title: const Text(AppConfig.kAppTitle),
        backgroundColor: Colors.transparent,
        border: BorderSide.none,
      ),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: kLoginFormWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kBigPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: space(
                    heightGap: kMediumPadding,
                    children: [
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
                        decoration: InputDecoration(
                          labelText: l10n.username,
                        ),
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
                            icon: Icon(
                              showPassword
                                  ? YaruIcons.eye_filled
                                  : YaruIcons.eye,
                            ),
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
                      const SizedBox(
                        height: kYaruTitleBarHeight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(seconds: 5),
              height: processingAccess ? 350 : 120,
              width: context.mediaQuerySize.width,
              child: LiquidLinearProgressIndicator(
                borderColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                borderWidth: 0,
                direction: Axis.vertical,
                valueColor: AlwaysStoppedAnimation(
                  context.colorScheme.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              height: 280,
              width: context.mediaQuerySize.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Icon(
                  YaruIcons.ubuntu_logo_simple,
                  size: 60,
                  color: context.theme.scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
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
