import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/view/confirm.dart';
import '../../l10n/l10n.dart';
import '../authentication_model.dart';

Future<void> uiaRequestHandler({
  required UiaRequest uiaRequest,
  required BuildContext context,
  required bool rootNavigator,
}) async {
  final l10n = context.l10n;
  var currentThreepidCreds = di<AuthenticationModel>().currentThreepidCreds;
  var currentClientSecret = di<AuthenticationModel>().currentClientSecret;
  final client = di<Client>();
  final navigatorContext = Navigator.of(
    context,
    rootNavigator: rootNavigator,
  ).context;
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
        final input = await showConfirmDialogWithInput(
          context: navigatorContext,
          title: l10n.pleaseEnterYourPassword,
          okLabel: l10n.ok,
          cancelLabel: l10n.cancel,
          hintText: l10n.password,
          obscureText: true,
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
          return uiaRequest.cancel(UiaException(l10n.serverRequiresEmail));
        }
        final auth = AuthenticationThreePidCreds(
          session: uiaRequest.session,
          type: AuthenticationTypes.emailIdentity,
          threepidCreds: ThreepidCreds(
            sid: currentThreepidCreds.sid,
            clientSecret: currentClientSecret,
          ),
        );
        return showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: Text(l10n.weSentYouAnEmail),
            content: Text(l10n.pleaseClickOnLink),
            confirmLabel: l10n.iHaveClickedOnLink,
            cancelLabel: l10n.cancel,
            onCancel: uiaRequest.cancel,
            onConfirm: () async => uiaRequest.completeStage(auth),
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

        return showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: Text(l10n.pleaseFollowInstructionsOnWeb),
            confirmLabel: l10n.next,
            onConfirm: () async => uiaRequest.completeStage(
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
