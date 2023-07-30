import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';

final class StringUtil {
  static String localizedMonthName(BuildContext context, DateTime date) => DateFormat.LLLL(_getLocale(context)).format(date);

  static String localizedDayName(BuildContext context, DateTime date) => DateFormat.EEEE(_getLocale(context)).format(date);

  static String localizedDayOfWeekName(BuildContext context, DateTime date) => DateFormat.EEEE(_getLocale(context)).format(date);

  static String localizedDayNameShort(BuildContext context, DateTime date) => DateFormat.E(_getLocale(context)).format(date);

  static String localizedMonthYear(BuildContext context, DateTime date) => DateFormat.yMMMM(_getLocale(context)).format(date);

  static String localizedDate(BuildContext context, DateTime date) {
    DateFormat format = DateFormat.yMd(_getLocale(context));
    String? pattern = format.pattern;
    return pattern == null
      ? format.format(date)
      // Padding
      : DateFormat(pattern.replaceFirst('d', 'dd').replaceFirst('M', 'MM')).format(date);
  }

  static String positionalDayData(BuildContext context, DateTime date) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);

    // Difference to today
    int difference = date.difference(now).inDays;
    String differenceString = difference >= 0
      ? localizations.dateDifferencePositive(difference)
      : localizations.dateDifferenceNegative(difference.abs());

    // Day of the year
    DateTime firstOfYear = DateTime(date.year);
    int dayOfYear = date.difference(firstOfYear).inDays;
    String serial = getSerial(context, dayOfYear);

    return localizations.dayInYear(localizedDate(context, date), differenceString, serial);
  }

  static String getSerial(BuildContext context, int number) {
    String locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'de': {
          return '$number' '.';
      }
      default: {
        switch (number) {
          case 1:
            return '1st';
          case 2:
            return '2nd';
          case 3:
            return '3rd';
          default:
            return '$number' 'th';
        }
      }
    }
  }

  static String _getLocale(BuildContext context) => Localizations.localeOf(context).languageCode;
}