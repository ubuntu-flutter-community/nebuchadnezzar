import 'dart:convert';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

import '../../../common/view/build_context_x.dart';
import '../../../l10n/l10n.dart';
import '../../view/chat_avatar.dart';

// TODO: code by fluffy-chat, replace
class KeyVerificationDialog extends StatefulWidget {
  Future<void> show(BuildContext context) => showAdaptiveDialog(
        context: context,
        builder: (context) => this,
        barrierDismissible: false,
      );

  final KeyVerification request;
  final Function()? onCancel;
  final Function()? onDone;

  const KeyVerificationDialog({
    super.key,
    required this.request,
    this.onCancel,
    this.onDone,
  });

  @override
  KeyVerificationPageState createState() => KeyVerificationPageState();
}

class KeyVerificationPageState extends State<KeyVerificationDialog> {
  void Function()? originalOnUpdate;
  late final List<dynamic> sasEmoji;

  @override
  void initState() {
    originalOnUpdate = widget.request.onUpdate;
    widget.request.onUpdate = () {
      originalOnUpdate?.call();
      setState(() {});
    };
    widget.request.client.getProfileFromUserId(widget.request.userId).then((p) {
      profile = p;
      setState(() {});
    });
    rootBundle.loadString('assets/sas-emoji.json').then((e) {
      sasEmoji = json.decode(e);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.request.onUpdate =
        originalOnUpdate; // don't want to get updates anymore
    if (![KeyVerificationState.error, KeyVerificationState.done]
        .contains(widget.request.state)) {
      widget.request.cancel('m.user');
    } else {}
    super.dispose();
  }

  Profile? profile;

  Future<void> checkInput(String input) async {
    if (input.isEmpty) return;

    final valid = await showFutureLoadingDialog(
      context: context,
      future: () async {
        // make sure the loading spinner shows before we test the keys
        await Future.delayed(const Duration(milliseconds: 100));
        var valid = false;
        try {
          await widget.request.openSSSS(keyOrPassphrase: input);
          valid = true;
        } catch (_) {
          valid = false;
        }
        return valid;
      },
    );
    if (valid.error != null && mounted) {
      await showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: 'incorrectPassphraseOrKey',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    User? user;
    final directChatId =
        widget.request.client.getDirectChatFromUserId(widget.request.userId);
    if (directChatId != null) {
      user = widget.request.client
          .getRoomById(directChatId)!
          .unsafeGetUserFromMemoryOrFallback(widget.request.userId);
    }
    final displayName =
        user?.calcDisplayname() ?? widget.request.userId.localpart!;
    var title = Text(l10n.verifyTitle);
    Widget body;
    final buttons = <Widget>[];

    switch (widget.request.state) {
      case KeyVerificationState.showQRSuccess:
      case KeyVerificationState.confirmQRScan:
        throw 'Not implemented';
      case KeyVerificationState.askSSSS:
        // prompt the user for their ssss passphrase / key
        final textEditingController = TextEditingController();
        String input;
        body = Container(
          margin: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                l10n.askSSSSSign,
                style: const TextStyle(fontSize: 20),
              ),
              Container(height: 10),
              TextField(
                controller: textEditingController,
                autofocus: false,
                autocorrect: false,
                onSubmitted: (s) {
                  input = s;
                  checkInput(input);
                },
                minLines: 1,
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: l10n.passphraseOrKey,
                  prefixStyle: TextStyle(color: theme.colorScheme.primary),
                  suffixStyle: TextStyle(color: theme.colorScheme.primary),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        );
        buttons.add(
          TextButton(
            child: Text(
              l10n.submit,
            ),
            onPressed: () => checkInput(textEditingController.text),
          ),
        );
        buttons.add(
          TextButton(
            child: Text(
              l10n.skip,
            ),
            onPressed: () => widget.request.openSSSS(skip: true),
          ),
        );
      case KeyVerificationState.askAccept:
        title = Text(l10n.newVerificationRequest);
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            ChatAvatar(
              avatarUri: user?.avatarUrl,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.askVerificationRequest(displayName),
            ),
          ],
        );
        buttons.add(
          TextButton.icon(
            icon: const Icon(Icons.close),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            label: Text(l10n.reject),
            onPressed: () => widget.request.rejectVerification().then((_) {
              if (context.mounted) {
                Navigator.of(context, rootNavigator: false).pop();
              }
            }),
          ),
        );
        buttons.add(
          TextButton.icon(
            icon: const Icon(Icons.check),
            label: Text(l10n.accept),
            onPressed: () => widget.request.acceptVerification(),
          ),
        );
      case KeyVerificationState.askChoice:
      case KeyVerificationState.waitingAccept:
        body = Center(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  ChatAvatar(
                    avatarUri: user?.avatarUrl,
                  ),
                  const SizedBox(
                    width: 38,
                    height: 38,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.waitingPartnerAcceptRequest,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
        buttons.add(
          TextButton.icon(
            icon: const Icon(Icons.close),
            label: Text(l10n.cancel),
            onPressed: () => widget.request.cancel(),
          ),
        );

      case KeyVerificationState.askSas:
        TextSpan compareWidget;
        // maybe add a button to switch between the two and only determine default
        // view for if "emoji" is a present sasType or not?

        if (widget.request.sasTypes.contains('emoji')) {
          title = Text(
            l10n.compareEmojiMatch,
            maxLines: 1,
            style: const TextStyle(fontSize: 16),
          );
          compareWidget = TextSpan(
            children: widget.request.sasEmojis
                .map((e) => WidgetSpan(child: _Emoji(e, sasEmoji)))
                .toList(),
          );
        } else {
          title = Text(l10n.compareNumbersMatch);
          final numbers = widget.request.sasNumbers;
          final numbstr = '${numbers[0]}-${numbers[1]}-${numbers[2]}';
          compareWidget =
              TextSpan(text: numbstr, style: const TextStyle(fontSize: 40));
        }
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text.rich(
              compareWidget,
              textAlign: TextAlign.center,
            ),
          ],
        );
        buttons.add(
          TextButton.icon(
            icon: const Icon(Icons.close),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            label: Text(l10n.theyDontMatch),
            onPressed: () => widget.request.rejectSas(),
          ),
        );
        buttons.add(
          TextButton.icon(
            icon: const Icon(Icons.check_outlined),
            label: Text(l10n.theyMatch),
            onPressed: () => widget.request.acceptSas(),
          ),
        );
      case KeyVerificationState.waitingSas:
        final acceptText = widget.request.sasTypes.contains('emoji')
            ? l10n.waitingPartnerEmoji
            : l10n.waitingPartnerNumbers;
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator.adaptive(strokeWidth: 2),
            const SizedBox(height: 10),
            Text(
              acceptText,
              textAlign: TextAlign.center,
            ),
          ],
        );
      case KeyVerificationState.done:
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outlined,
              color: Colors.green,
              size: 128.0,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.verifySuccess,
              textAlign: TextAlign.center,
            ),
          ],
        );
        buttons.add(
          TextButton(
            child: Text(
              l10n.close,
            ),
            onPressed: () {
              widget.onDone?.call();
              if (context.mounted) {
                Navigator.of(
                  context,
                  rootNavigator: false,
                ).pop();
              }
            },
          ),
        );
      case KeyVerificationState.error:
        title = const Text('');
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cancel, color: Colors.red, size: 128.0),
            const SizedBox(height: 16),
            Text(
              'Error ${widget.request.canceledCode}: ${widget.request.canceledReason}',
              textAlign: TextAlign.center,
            ),
          ],
        );
        buttons.add(
          TextButton(
            child: Text(
              l10n.close,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
          ),
        );
    }

    return AlertDialog.adaptive(
      title: title,
      content: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: 256,
          width: 256,
          child: ListView(
            children: [body],
          ),
        ),
      ),
      actions: buttons,
    );
  }
}

class _Emoji extends StatelessWidget {
  final KeyVerificationEmoji emoji;
  final List<dynamic>? sasEmoji;

  const _Emoji(this.emoji, this.sasEmoji);

  String getLocalizedName() {
    final sasEmoji = this.sasEmoji;
    if (sasEmoji == null) {
      // asset is still being loaded
      return emoji.name;
    }
    final translations = Map<String, String?>.from(
      sasEmoji[emoji.number]['translated_descriptions'],
    );
    translations['en'] = emoji.name;
    for (final locale in PlatformDispatcher.instance.locales) {
      final wantLocaleParts = locale.toString().split('_');
      final wantLanguage = wantLocaleParts.removeAt(0);
      for (final haveLocale in translations.keys) {
        final haveLocaleParts = haveLocale.split('_');
        final haveLanguage = haveLocaleParts.removeAt(0);
        if (haveLanguage == wantLanguage &&
            (Set.from(haveLocaleParts)..removeAll(wantLocaleParts)).isEmpty &&
            (translations[haveLocale]?.isNotEmpty ?? false)) {
          return translations[haveLocale]!;
        }
      }
    }
    return emoji.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(emoji.emoji, style: const TextStyle(fontSize: 50)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(getLocalizedName()),
        ),
        const SizedBox(height: 10, width: 5),
      ],
    );
  }
}
