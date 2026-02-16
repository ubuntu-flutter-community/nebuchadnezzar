import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaru/yaru.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../app_config.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.error,
    this.onRetry,
    this.onRetryLabel,
    this.addQuitButton = false,
  });

  final Object? error;
  final void Function()? onRetry;
  final String? onRetryLabel;
  final bool addQuitButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: Text(context.l10n.oopsSomethingWentWrong),
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      body: ErrorBody(
        error: error,
        onRetryLabel: onRetryLabel,
        onRetry: onRetry,
        addQuitButton: addQuitButton,
      ),
    );
  }
}

class ErrorBody extends StatelessWidget {
  const ErrorBody({
    super.key,
    required this.error,
    this.onRetry,
    this.onRetryLabel,
    this.addQuitButton = false,
  });

  final Object? error;
  final void Function()? onRetry;
  final String? onRetryLabel;
  final bool addQuitButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kBigPadding),
        child: SizedBox(
          width: 350,
          child: ListView(
            shrinkWrap: true,
            children: [
              const Icon(Icons.bug_report_outlined, size: 100),
              const SizedBox(height: kMediumPadding),
              YaruExpandable(
                header: Text(
                  error.toString().split(': ').firstOrNull ?? error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                child: SelectableText(error.toString()),
              ),
              const SizedBox(height: 2 * kBigPadding),
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: kMediumPadding,
                children: [
                  if (onRetry != null)
                    ...[
                      ElevatedButton.icon(
                        icon: const Icon(YaruIcons.refresh),
                        onPressed: onRetry,
                        label: Text(onRetryLabel ?? context.l10n.retry),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(YaruIcons.send),
                        onPressed: () {
                          final String body =
                              '''
**Describe the bug**

A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Additional context**
Add any other context about the problem here.

**Error Log**
```
------------ Platform: ------------
Platform: ${kIsWeb ? 'Web' : Platform.operatingSystem} ${kIsWeb ? '' : Platform.operatingSystemVersion}
           
------------ Error: ------------
${error.toString().splitMapJoin(RegExp('.{1,100}'), onMatch: (m) => '${m.group(0)}\n', onNonMatch: (n) => n)}
```
''';
                          launchUrl(
                            Uri(
                              scheme: AppConfig.scheme,
                              host: AppConfig.host,
                              path:
                                  '/${AppConfig.owner}/${AppConfig.repo}/issues/new',
                              queryParameters: {
                                'title':
                                    'fix: ${error.toString().split(':').firstOrNull ?? 'error'}',
                                'body': body,
                              },
                            ),
                          );
                        },
                        label: Text(context.l10n.reportIssue),
                      ),
                      if (addQuitButton)
                        OutlinedButton.icon(
                          icon: const Icon(YaruIcons.window_close),
                          onPressed: () => exit(0),
                          label: Text(context.l10n.closeApp),
                        ),
                    ].map((e) => SizedBox(width: 250.0, child: e)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
