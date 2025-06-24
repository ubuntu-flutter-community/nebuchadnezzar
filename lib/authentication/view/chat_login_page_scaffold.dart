import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/space.dart';
import '../../common/view/ui_constants.dart';

class ChatLoginPageScaffold extends StatelessWidget {
  const ChatLoginPageScaffold({
    super.key,
    required this.content,
    required this.processingAccess,
    required this.titleLabel,
    required this.canPop,
  });

  final List<Widget> content;
  final bool processingAccess;
  final String titleLabel;
  final bool canPop;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: YaruWindowTitleBar(
      leading: processingAccess || !canPop
          ? null
          : YaruBackButton(onPressed: () => Navigator.of(context).maybePop()),
      title: Text(titleLabel),
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
                children: space(heightGap: kMediumPadding, children: content),
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
