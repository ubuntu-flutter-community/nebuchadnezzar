import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n.dart';

extension DateTimeX on DateTime {
  String formatAndLocalize(AppLocalizations l10n, {bool simple = false}) {
    final now = DateTime.now();

    final countryCode =
        Platform.localeName == 'und' ? 'en' : Platform.localeName;

    if (!simple && year == now.year && month == now.month) {
      if (day == now.day - 1) {
        return '${l10n.yesterday}, ${DateFormat.Hm(
          countryCode,
        ).format(this)}';
      } else if (day == now.day) {
        return DateFormat.Hm(
          countryCode,
        ).format(this);
      }
    }
    return DateFormat.yMd(
      countryCode,
    ).add_Hm().format(this);
  }

  String formatAndLocalizeDay(AppLocalizations l10n) {
    final now = DateTime.now();
    final locale = WidgetsBinding.instance.platformDispatcher.locale;

    if (year == now.year && month == now.month) {
      if (day == now.day - 1) {
        return l10n.yesterday;
      }
    }
    return DateFormat.yMd(
      locale.countryCode,
    ).format(this);
  }

  String formatAndLocalizeTime(AppLocalizations l10n) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;

    return DateFormat.Hm(
      locale.countryCode,
    ).format(this);
  }
}
