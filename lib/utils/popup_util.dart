import 'dart:math';

import 'package:canalendar/enumerations/stock_type.dart';
import 'package:canalendar/models/persistency/save_data.dart';
import 'package:canalendar/utils/dropdown_map_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class PopupUtil {
  static void openRegisterUserAlert(BuildContext context, {bool isDismissable = true}) {
    ValueNotifier<int> selectedStockTypeIndex = ValueNotifier(StockType.weed.index);
    ValueNotifier<TimeOfDay> selectedTime = ValueNotifier(TimeOfDay(hour: 0, minute: 0));

    AppLocalizations localization = AppLocalizations.of(context)!;

    TextFormField nameInput = TextFormField(
      decoration: InputDecoration(
        labelText: localization.name,
        border: const OutlineInputBorder(),
      ),
      autocorrect: false,
    );


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                title: Text(localization.registerUser),
                content: Column(
                  children: [
                    nameInput,
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(localization.standardStockType),
                        const SizedBox(width: 32),
                        ValueListenableBuilder(
                          valueListenable: selectedStockTypeIndex,
                          builder: (context, value, _) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16), // Hier kannst du den Radius für die runden Ecken einstellen
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                                  padding: const EdgeInsets.only(left: 16, right: 8),
                                  value: selectedStockTypeIndex.value,
                                  onChanged: (index) {
                                    selectedStockTypeIndex.value = index!;
                                  },
                                  items: DropdownMapUtil.getStockTypeOptions(context).map((item) {
                                    int index = DropdownMapUtil.getStockTypeOptions(context).indexOf(item);
                                    return DropdownMenuItem<int>(
                                      value: index,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                )
                              )
                            );
                          }
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(localization.daySeparator),
                        const SizedBox(width: 32),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onTap: () => _selectTime(context,
                                        (time) => selectedTime.value = time),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: ValueListenableBuilder(
                                valueListenable: selectedTime,
                                builder: (context, value, _) {
                                  return Text(selectedTime.value.format(context));
                                }
                              )
                            )
                          )
                        )
                      ],
                    )
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      SaveData.instance!.addUser(nameInput.controller!.text, selectedTime.value, standardType: StockType.values[selectedStockTypeIndex.value]);
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              )
            ]
          )
        );
      },
      barrierDismissible: isDismissable,
    );
  }

  static Future<void> _selectTime(BuildContext context,
      Function(TimeOfDay selectedTime) onTimeSelected, {TimeOfDay? initialTime}) async {
    initialTime ??= const TimeOfDay(hour: 0, minute: 0);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null && picked != initialTime) {
      onTimeSelected(picked);
    }
  }
}