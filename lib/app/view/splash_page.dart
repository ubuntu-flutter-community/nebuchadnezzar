import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../settings/view/chat_settings_logout_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key, this.title});

  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: title,
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
        actions: const [
          Flexible(child: ChatSettingsLogoutButton()),
          SizedBox(width: kSmallPadding),
        ],
      ),
      body: const Center(
        child: Progress(),
      ),
    );
  }
}
