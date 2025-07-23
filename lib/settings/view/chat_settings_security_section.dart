import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../settings_model.dart';

class ChatSettingsSecuritySection extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ChatSettingsSecuritySection({super.key});

  @override
  State<ChatSettingsSecuritySection> createState() =>
      _ChatSettingsSecuritySectionState();
}

class _ChatSettingsSecuritySectionState
    extends State<ChatSettingsSecuritySection> {
  late final int _initialIndex;

  @override
  void initState() {
    super.initState();
    _initialIndex = di<SettingsModel>().shareKeysWithIndex;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final shareKeysWith = watchPropertyValue(
      (SettingsModel m) => ShareKeysWith.values[m.shareKeysWithIndex],
    );

    return YaruSection(
      headline: Text(l10n.security),
      child: Column(
        children: [
          YaruTile(
            leading: const Text('Share keys with'),
            trailing: YaruPopupMenuButton<ShareKeysWith>(
              initialValue: shareKeysWith,
              onSelected: (v) =>
                  di<SettingsModel>().setShareKeysWithIndex(v.index),
              itemBuilder: (context) => ShareKeysWith.values
                  .map(
                    (e) => PopupMenuItem<ShareKeysWith>(
                      value: e,
                      child: Text(e.localize(l10n)),
                    ),
                  )
                  .toList(),
              child: Text(shareKeysWith.localize(l10n)),
            ),
          ),
          if (shareKeysWith.index != _initialIndex)
            YaruInfoBox(
              yaruInfoType: YaruInfoType.information,
              title: const Text('Requires a restart of the application.'),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: YaruInfoType.information
                        .getColor(context)
                        .withValues(alpha: 0.1),
                  ),

                  onPressed: () => exit(0),
                  child: const Text('Close app'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

extension _ShareKeysWithX on ShareKeysWith {
  // TODO: localize
  String localize(AppLocalizations l10n) => switch (this) {
    ShareKeysWith.all => l10n.all,
    ShareKeysWith.crossVerifiedIfEnabled => 'crossVerifiedIfEnabled',
    ShareKeysWith.crossVerified => 'crossVerified',
    ShareKeysWith.directlyVerifiedOnly => 'directlyVerifiedOnly',
  };
}
