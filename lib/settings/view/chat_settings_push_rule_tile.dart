import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      bottom: kMediumPadding,
      left: kMediumPadding,
      right: kBigPadding,
    ),
    child: YaruExpandable(
      expandButtonPosition: YaruExpandableButtonPosition.start,
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(rule.getPushRuleName(context.l10n))),
          Row(
            spacing: kSmallPadding,
            children: [
              IconButton(
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
                    await di<AccountManager>().deletePushRule(
                      kind,
                      rule.ruleId,
                    );
                    await di<AccountManager>().pushRuleUpdateFuture;
                  },
                ),
                icon: const Icon(YaruIcons.trash),
              ),
              Switch(
                value: rule.enabled,
                onChanged: di<AccountManager>().getDisabledRule(rule.ruleId)
                    ? null
                    : (_) => showFutureLoadingDialog(
                        context: context,
                        future: () =>
                            di<AccountManager>().togglePushRule(kind, rule),
                      ),
              ),
            ],
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kSmallPadding,
          horizontal: kBigPadding,
        ),
        child: Column(
          spacing: kBigPadding,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  rule.getPushRuleDescription(context.l10n),
                  style: context.textTheme.labelMedium,
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.link.withAlpha(15),
                borderRadius: BorderRadius.circular(kMediumPadding),
              ),
              padding: const EdgeInsets.all(kMediumPadding),
              child: SelectableText(
                _prettyJson(rule.toJson()),
                style: TextStyle(
                  color: context.theme.colorScheme.link,
                  fontSize: 12,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
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
