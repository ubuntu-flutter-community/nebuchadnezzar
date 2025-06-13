import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/common_widgets.dart';

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
      ),
      body: const Center(child: Progress()),
    );
  }
}
