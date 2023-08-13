import 'package:canalendar/enumerations/session_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/amounts.dart';
import '../utils/icon_util.dart';

class IconAmountComponent extends StatelessWidget {
  final SessionType _type;
  late ValueNotifier<int> _amount;

  IconAmountComponent({super.key, SessionType type = SessionType.joint,
    ValueNotifier<Amounts>? amountsNotifier})
      : _type = type {
    if (amountsNotifier == null) {
      _amount = ValueNotifier(0);
    }
    else {
      switch (type) {
        case SessionType.joint: {
          _amount = ValueNotifier(amountsNotifier.value.joints);
          break;
        }
        case SessionType.sticky: {
          _amount = ValueNotifier(amountsNotifier.value.stickies);
          break;
        }
        case SessionType.edible: {
          _amount = ValueNotifier(amountsNotifier.value.edibles);
          break;
        }
        case SessionType.bong: {
          _amount = ValueNotifier(amountsNotifier.value.bongs);
          break;
        }
      }
    }
  }

  void setAmount(int amount) => _amount.value = amount;
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _amount,
      builder: (context, amount, child) {
        return Visibility(
          visible: amount > 0,
          child: Wrap(
            children: [
              SvgPicture.asset(
                IconUtil.getSessionTypeIconPath(_type),
                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                width: 20,
                height: 20,
              ),
              Text(amount.toString())
            ],
          )
        );
      }
    );
  }
  
}