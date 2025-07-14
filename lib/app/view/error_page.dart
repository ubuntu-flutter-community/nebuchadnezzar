import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import '../../l10n/l10n.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: Text(context.l10n.oopsSomethingWentWrong),
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      body: ErrorBody(error: error),
    );
  }
}

class ErrorBody extends StatelessWidget {
  const ErrorBody({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('An error occurred: $error'));
  }
}
