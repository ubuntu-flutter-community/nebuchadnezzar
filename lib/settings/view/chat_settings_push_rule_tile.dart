// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/push_rule_extension.dart';
import '../../l10n/l10n.dart';
import '../account_manager.dart';

class ChatSettingsPushRuleTile extends StatelessWidget {
  const ChatSettingsPushRuleTile({
    super.key,
    required this.rule,
    required this.kind,
  });

  final PushRule rule;
  final PushRuleKind kind;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.only(
      left: kMediumPadding,
      right: kBigPadding,
      bottom: kSmallPadding,
    ),
    title: YaruExpandable(
      expandButtonPosition: YaruExpandableButtonPosition.start,
      header: Text(rule.getPushRuleName(context.l10n)),
      child: Padding(
        padding: const EdgeInsets.all(kSmallPadding),
        child: Column(
          spacing: kSmallPadding,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () async => ConfirmationDialog.show(
                context: context,
                content: Text(
                  context.l10n.deletePushRuleDescription(
                    rule.getPushRuleName(context.l10n),
                  ),
                ),
                title: Text(
                  context.l10n.deletePushRuleTitle(
                    rule.getPushRuleName(context.l10n),
                  ),
                ),
                onConfirm: () async {
                  await di<AccountManager>().deletePushRule(kind, rule.ruleId);
                  await di<AccountManager>().pushRuleUpdateFuture;
                },
              ),
              label: Text(context.l10n.delete),
              icon: const Icon(YaruIcons.trash),
            ),
            SelectableText(
              _prettyJson(rule.toJson()),
              style: TextStyle(
                color: context.theme.colorScheme.link,
                fontSize: 12,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    ),
    trailing: Switch(
      value: rule.enabled,
      onChanged: di<AccountManager>().getDisabledRule(rule.ruleId)
          ? null
          : (_) => showFutureLoadingDialog(
              context: context,
              future: () => di<AccountManager>().togglePushRule(kind, rule),
            ),
    ),
  );

  String _prettyJson(Map<String, Object?> json) {
    const decoder = JsonDecoder();
    const encoder = JsonEncoder.withIndent('    ');
    final object = decoder.convert(jsonEncode(json));
    return encoder.convert(object);
  }
}
