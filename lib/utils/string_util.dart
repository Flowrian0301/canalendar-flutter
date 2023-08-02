import 'package:canalendar/enumerations/stock_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:intl/intl.dart';

final class StringUtil {
  static String getMonthName(BuildContext context, DateTime date) => DateFormat.LLLL(_getLocale(context)).format(date);

  static String getDayName(BuildContext context, DateTime date) => DateFormat.EEEE(_getLocale(context)).format(date);

  static String getDayOfWeekName(BuildContext context, DateTime date) => DateFormat.EEEE(_getLocale(context)).format(date);

  static String getDayNameShort(BuildContext context, DateTime date) => DateFormat.E(_getLocale(context)).format(date);

  static String getMonthYear(BuildContext context, DateTime date) => DateFormat.yMMMM(_getLocale(context)).format(date);

  static String getlocalizedDate(BuildContext context, DateTime date) {
    DateFormat format = DateFormat.yMd(_getLocale(context));
    String? pattern = format.pattern;
    return pattern == null
      ? format.format(date)
      // Padding
      : DateFormat(pattern.replaceFirst('d', 'dd').replaceFirst('M', 'MM')).format(date);
  }

  static String getPositionalDayData(BuildContext context, DateTime date) {
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

    return localizations.dayInYear(getlocalizedDate(context, date), differenceString, serial);
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

  static String getStockTypeName(BuildContext context, StockType type) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    switch (type) {
      case StockType.hash:
        return localizations.hash;
      case StockType.hhc_weed:
        return localizations.hhc_weed;
      case StockType.hhc_hash:
        return localizations.hhc_hash;
      case StockType.cbd_weed:
        return localizations.cbd_weed;
      case StockType.cbd_hash:
        return localizations.cbd_hash;
      default:
        return localizations.weed;
    }
  }

  static String _getLocale(BuildContext context) => Localizations.localeOf(context).languageCode;
}