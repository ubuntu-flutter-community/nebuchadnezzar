import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/space.dart';
import '../../common/view/ui_constants.dart';
import '../../constants.dart';
import '../../l10n/l10n.dart';
import '../bootstrap/view/bootstrap_page.dart';
import 'authentication_model.dart';
import 'chat_matrix_id_login_page.dart';

class ChatLoginPage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatLoginPage({super.key});

  @override
  State<ChatLoginPage> createState() => _ChatLoginPageState();
}

class _ChatLoginPageState extends State<ChatLoginPage> {
  final TextEditingController _homeServerController =
      TextEditingController(text: 'matrix.org');
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    bool processingAccess =
        watchPropertyValue((AuthenticationModel m) => m.processingAccess);

    var onPressed = processingAccess
        ? null
        : () => di<AuthenticationModel>().ssoLogin(
              onSuccess: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const CheckBootstrapPage(),
                ),
                (route) => false,
              ),
              onFail: (e) => showSnackBar(
                context,
                content: Text(e.toString()),
              ),
              homeServer: _homeServerController.text.trim(),
            );
    return Scaffold(
      appBar: const YaruWindowTitleBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        border: BorderSide.none,
      ),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: kLoginFormWidth,
              child: Padding(
                padding: const EdgeInsets.only(bottom: kYaruTitleBarHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: space(
                    heightGap: kMediumPadding,
                    children: [
                      Text(
                        kAppTitle,
                        style: context.theme.textTheme.headlineLarge,
                      ),
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
                          icon: const Icon(
                            YaruIcons.globe,
                          ),
                          label: Text(l10n.login),
                        ),
                      ),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(l10n.or),
                          ),
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
                                      builder: (_) =>
                                          const ChatMatrixIdLoginPage(),
                                    ),
                                  ),
                          label: Text(l10n.loginWithMatrixId),
                        ),
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
}
