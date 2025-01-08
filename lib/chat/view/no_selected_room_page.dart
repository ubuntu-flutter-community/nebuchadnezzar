import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import 'side_bar_button.dart';

class NoSelectedRoomPage extends StatelessWidget {
  const NoSelectedRoomPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: YaruWindowTitleBar(
          heroTag: '<Right hero tag>',
          border: BorderSide.none,
          backgroundColor: Colors.transparent,
          title: const Text(''),
          leading: !kIsWeb && !Platform.isMacOS && !context.showSideBar
              ? const SideBarButton()
              : null,
          actions: [
            if (!context.showSideBar && !kIsWeb && Platform.isMacOS)
              const SideBarButton(),
          ],
        ),
        body: const Center(
          child: Text('Please select a chatroom'),
        ),
      );
}
