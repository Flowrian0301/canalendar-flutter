import 'package:canalendar/enumerations/stock_type.dart';
import 'package:canalendar/utils/string_util.dart';
import 'package:flutter/material.dart';

final class DropdownMapUtil {
  static List<String> getStockTypeOptions(BuildContext context) {
    List<String> stockTypes = [];
    for (StockType type in StockType.values) {
      stockTypes.add(StringUtil.getStockTypeName(context, type));
    }
    return stockTypes;
  }
}