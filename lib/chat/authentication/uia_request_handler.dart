import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../common/view/show_text_input_dialog.dart';
import 'authentication_model.dart';

Future uiaRequestHandler({
  required UiaRequest uiaRequest,
  required BuildContext context,
}) async {
  final l10n = context.l10n;
  var currentThreepidCreds = di<AuthenticationModel>().currentThreepidCreds;
  var currentClientSecret = di<AuthenticationModel>().currentClientSecret;
  final client = di<Client>();
  final navigatorContext = Navigator.of(context).context;
  try {
    if (uiaRequest.state != UiaRequestState.waitForUser ||
        uiaRequest.nextStages.isEmpty) {
      Logs().d('Uia Request Stage: ${uiaRequest.state}');
      return;
    }
    final stage = uiaRequest.nextStages.first;
    Logs().d('Uia Request Stage: $stage');
    switch (stage) {
      case AuthenticationTypes.password:
        final input = await showTextInputDialog(
          context: navigatorContext,
          title: l10n.pleaseEnterYourPassword,
          okLabel: l10n.ok,
          cancelLabel: l10n.cancel,
          hintText: '******',
        );
        if (input == null || input.isEmpty) {
          return uiaRequest.cancel();
        }
        return uiaRequest.completeStage(
          AuthenticationPassword(
            session: uiaRequest.session,
            password: input,
            identifier: AuthenticationUserIdentifier(user: client.userID!),
          ),
        );
      case AuthenticationTypes.emailIdentity:
        if (currentThreepidCreds == null) {
          return uiaRequest.cancel(
            UiaException(l10n.serverRequiresEmail),
          );
        }
        final auth = AuthenticationThreePidCreds(
          session: uiaRequest.session,
          type: AuthenticationTypes.emailIdentity,
          threepidCreds: ThreepidCreds(
            sid: currentThreepidCreds.sid,
            clientSecret: currentClientSecret,
          ),
        );
        showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: Text(l10n.weSentYouAnEmail),
            content: Text(l10n.pleaseClickOnLink),
            confirmLabel: l10n.iHaveClickedOnLink,
            cancelLabel: l10n.cancel,
            onCancel: uiaRequest.cancel,
            onConfirm: () => uiaRequest.completeStage(auth),
          ),
        );

      case AuthenticationTypes.dummy:
        return uiaRequest.completeStage(
          AuthenticationData(
            type: AuthenticationTypes.dummy,
            session: uiaRequest.session,
          ),
        );
      default:
        final url = Uri.parse(
          '${client.homeserver}/_matrix/client/r0/auth/$stage/fallback/web?session=${uiaRequest.session}',
        );
        launchUrlString(url.toString());

        showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: Text(l10n.pleaseFollowInstructionsOnWeb),
            confirmLabel: l10n.next,
            onConfirm: () => uiaRequest.completeStage(
              AuthenticationData(session: uiaRequest.session),
            ),
            onCancel: uiaRequest.cancel,
          ),
        );
    }
  } catch (e, s) {
    Logs().e('Error while background UIA', e, s);
    return uiaRequest.cancel(e is Exception ? e : Exception(e));
  }
}

class UiaException implements Exception {
  final String reason;

  UiaException(this.reason);

  @override
  String toString() => reason;
}
