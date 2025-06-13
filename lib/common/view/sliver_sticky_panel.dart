import 'package:flutter/material.dart';

import 'build_context_x.dart';
import 'theme.dart';

class SliverStickyPanel extends StatelessWidget {
  const SliverStickyPanel({
    super.key,
    required this.child,
    this.toolbarHeight = 48.0,
    this.padding,
    this.backgroundColor,
  });

  final Widget child;
  final double toolbarHeight;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: const RoundedRectangleBorder(side: BorderSide.none),
      elevation: 0,
      backgroundColor: backgroundColor ?? getPanelBg(context.theme),
      automaticallyImplyLeading: false,
      pinned: true,
      centerTitle: true,
      titleSpacing: 0,
      toolbarHeight: toolbarHeight,
      actions: [Container()],
      title: Padding(
        padding:
            padding ?? const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: child,
      ),
    );
  }
}
