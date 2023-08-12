import 'package:canalendar/enumerations/session_type.dart';
import 'package:canalendar/models/amounts.dart';
import 'package:canalendar/views/icon_amount_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DayAmounts extends StatelessWidget {
  ValueNotifier<Amounts> _amounts = ValueNotifier(Amounts());

  void setAmounts(Amounts amounts) => _amounts.value = amounts;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return ValueListenableBuilder(
        valueListenable: _amounts,
        builder: (context, amounts, children) {
          return Wrap(
            children: [
              Text(amounts.isEmpty ? localizations.no_entry : ''),
              IconAmountComponent(type: SessionType.joint, amountsNotifier: _amounts),
              IconAmountComponent(type: SessionType.sticky, amountsNotifier: _amounts),
              IconAmountComponent(type: SessionType.edible, amountsNotifier: _amounts),
              IconAmountComponent(type: SessionType.bong, amountsNotifier: _amounts),
            ],
          );
        }
    );
  }


}