import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n.dart';

extension DateTimeX on DateTime {
  String formatAndLocalize(BuildContext context, {bool simple = false}) {
    final now = DateTime.now();
    final l10n = context.l10n;

    var localeName = WidgetsBinding.instance.platformDispatcher.locale
        .toString();
    var bool = localeName == 'und' || localeName == 'US';
    final countryCode = bool ? 'en' : localeName;

    if (!simple && year == now.year && month == now.month) {
      if (day == now.day - 1) {
        return '${l10n.yesterday}, ${DateFormat.Hm(countryCode).format(this)}';
      } else if (day == now.day) {
        return DateFormat.Hm(countryCode).format(this);
      }
    }
    return DateFormat.yMd(countryCode).add_Hm().format(this);
  }

  String formatAndLocalizeTime(BuildContext context) =>
      DateFormat.Hm(context.l10n.localeName).format(this);

  String formatAndLocalizeDay(BuildContext context) {
    final now = DateTime.now();
    final locale = context.l10n.localeName;

    if (year == now.year && month == now.month) {
      if (day == now.day - 1) {
        return context.l10n.yesterday;
      }
    }
    return DateFormat.yMd(locale).format(this);
  }

  String formatAndLocalizeDateTime(BuildContext context) =>
      '${formatAndLocalizeDay(context)}, ${formatAndLocalizeTime(context)}';
}
