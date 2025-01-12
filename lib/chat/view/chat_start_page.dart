import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/common_widgets.dart';
import '../authentication/chat_login_page.dart';
import '../chat_model.dart';
import 'chat_master/chat_master_detail_page.dart';

class ChatStartPage extends StatefulWidget {
  const ChatStartPage({super.key});

  @override
  State<ChatStartPage> createState() => _ChatStartPageState();
}

class _ChatStartPageState extends State<ChatStartPage> {
  late final Future<void> _registrationReady;

  @override
  void initState() {
    super.initState();
    _registrationReady = di.allReady();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _registrationReady,
        builder: (context, snapshot) => snapshot.hasData
            ? (!di<ChatModel>().isLogged)
                ? const ChatLoginPage()
                : const ChatMasterDetailPage()
            : const Scaffold(
                appBar: YaruWindowTitleBar(
                  border: BorderSide.none,
                  backgroundColor: Colors.transparent,
                ),
                body: Center(
                  child: Progress(),
                ),
              ),
      );
}
