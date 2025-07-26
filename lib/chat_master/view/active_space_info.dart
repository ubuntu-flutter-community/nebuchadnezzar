import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';
import '../../common/chat_model.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/sliver_sticky_panel.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';

class ActiveSpaceInfo extends StatelessWidget with WatchItMixin {
  const ActiveSpaceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textTheme = theme.textTheme;
    final activeSpace = watchPropertyValue((ChatModel m) => m.activeSpace);

    if (activeSpace == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverStickyPanel(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(
          left: kSmallPadding,
          right: kSmallPadding,
          top: kSmallPadding,
        ),
        child: ListTile(
          title: Text(activeSpace.getLocalizedDisplayname()),
          subtitle: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              borderRadius: BorderRadius.circular(kSmallPadding),
              onTap: () => showSnackBar(
                context,
                content: CopyClipboardContent(text: activeSpace.canonicalAlias),
              ),
              child: Text(
                activeSpace.canonicalAlias,
                style: textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.link,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
