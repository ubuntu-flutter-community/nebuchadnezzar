import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../authentication/authentication_service.dart';
import '../../authentication/view/chat_login_page.dart';
import '../../authentication/view/uia_request_handler.dart';
import '../../common/view/build_context_x.dart';

mixin ChatGlobalHandlerMixin {
  void registerGlobalChatHandlers() {
    registerStreamHandler(
      select: (AuthenticationService m) => m.onUiaRequestStream,
      handler: (context, newValue, cancel) async {
        if (newValue.hasData) {
          await uiaRequestHandler(
            uiaRequest: newValue.data!,
            context: context,
            rootNavigator: true,
          );
        }
      },
    );

    registerStreamHandler(
      select: (AuthenticationService m) => m.loginStateStream,
      handler: (context, newValue, cancel) {
        if (newValue.hasData && newValue.data != LoginState.loggedIn) {
          context.teleport((_) => const ChatLoginPage());
        }
      },
    );
  }
}
