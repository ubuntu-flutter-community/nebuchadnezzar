import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../app/view/error_page.dart';
import '../../app/view/splash_page.dart';
import '../../chat_master/view/chat_master_detail_page.dart';
import '../../l10n/l10n.dart';
import '../encryption_model.dart';
import 'setup_encrypted_chat_page.dart';

class CheckEncryptionSetupPage extends StatefulWidget {
  const CheckEncryptionSetupPage({super.key});

  @override
  State<CheckEncryptionSetupPage> createState() =>
      _CheckEncryptionSetupPageState();
}

class _CheckEncryptionSetupPageState extends State<CheckEncryptionSetupPage> {
  late Future<bool> _isEncryptionSetupNeeded;

  @override
  void initState() {
    super.initState();
    _isEncryptionSetupNeeded = di<EncryptionModel>()
        .checkIfEncryptionSetupIsNeeded();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _isEncryptionSetupNeeded,
    builder: (context, snapshot) => snapshot.hasError
        ? ErrorPage(error: snapshot.error.toString())
        : snapshot.hasData
        ? (snapshot.data == true
              ? const SetupEncryptedChatPage()
              : const ChatMasterDetailPage())
        : SplashPage(title: Text(context.l10n.loadingPleaseWait)),
  );
}
