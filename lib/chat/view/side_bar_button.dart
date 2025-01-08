import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/scaffold_state_x.dart';
import '../../common/view/ui_constants.dart';
import 'chat_master/chat_master_detail_page.dart';

class SideBarButton extends StatelessWidget {
  const SideBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
      child: Center(
        child: IconButton(
          onPressed: masterScaffoldKey.currentState?.showDrawer,
          icon: const Icon(YaruIcons.sidebar),
        ),
      ),
    );
  }
}
