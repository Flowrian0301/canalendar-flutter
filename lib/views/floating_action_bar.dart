import 'dart:io';

import 'package:canalendar/enumerations/session_type.dart';
import 'package:canalendar/models/persistency/save_data.dart';
import 'package:canalendar/models/session.dart';
import 'package:canalendar/utils/icon_util.dart';
import 'package:canalendar/utils/string_util.dart';
import 'package:canalendar/views/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FloatingActionBar extends StatelessWidget {
  VoidCallback onDayDataChanged;

  FloatingActionBar(this.onDayDataChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> btns = createButtons(context);
    return Align(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        child: Wrap(
          children: btns
        )
      )
    );
  }

  List<Widget> createButtons(BuildContext context) {
    List<Widget> btns = [];
    for (SessionType type in SessionType.values) {
      btns.add(
          ValueListenableBuilder(
              valueListenable: SaveData.currentUser,
              builder: (context, user, child) =>
                  _createSessionButton(context, type)
          )
      );
    }

    AppLocalizations localization = AppLocalizations.of(context)!;

    List<_PopupMenuItemData> purchaseMenuItems = [
      _PopupMenuItemData(
          localization.add,
          Icons.add
      ),
      _PopupMenuItemData(
          localization.edit,
          Icons.edit
      ),
      _PopupMenuItemData(
          localization.set_finished_date,
          Icons.check
      ),
      _PopupMenuItemData(
          localization.manage_stocks,
          Icons.list
      ),
    ];

    btns.add(
      _createButton(
        context,
        IconUtil.getPurchaseIconPath(),
        localization.stock,
        purchaseMenuItems,
        (p0) => null
      )
    );

    return btns;
  }

  bool _dateInFutureCheck(BuildContext context) {
    if (CalendarView.selectedDate.isAfter(DateTime.now())) {
      AppLocalizations localizations = AppLocalizations.of(context)!;
      if (Platform.isIOS || Platform.isAndroid) {
        Fluttertoast.showToast(
          msg: localizations.date_is_in_future_message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.date_is_in_future_message),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return true;
    }
    return false;
  }

  Widget _createSessionButton(BuildContext context, SessionType type) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    String tooltip = StringUtil.getSessionTypeName(context, type);
    String iconName = IconUtil.getSessionTypeIconPath(type);

    List<_PopupMenuItemData> dropdownItems = [
      _PopupMenuItemData(
          localization.users_stock(
          SaveData.currentUser.value == null
              ? '' : SaveData.currentUser.value!.name!),
          Icons.add
      ),
      _PopupMenuItemData(
          localization.anybodys_stock,
          Icons.add
      ),
      _PopupMenuItemData(
          localization.edit_amount,
          Icons.edit
      ),
      _PopupMenuItemData(
          localization.add_pro,
          Icons.more_horiz
      ),
      _PopupMenuItemData(
          localization.settings,
          Icons.settings
      ),
    ];

    onSelected(index) {
      switch (index) {
        case 1: {
          if (!_dateInFutureCheck(context)) {
            SaveData.addSessionToCurrentUser(
                Session.fromOtherUser(type, SaveData.currentUser.value!.standardType,
                    CalendarView.selectedDate)
            );
            //update cell
            onDayDataChanged();
          }
          break;
        }
      }
    }

    return _createButton(context, iconName, tooltip, dropdownItems, onSelected);
  }

  Widget _createButton(BuildContext context, String iconName, String tooltip,
      List<_PopupMenuItemData> dropdownItems, Function(int) onSelected) {

    return PopupMenuButton(
      onSelected: onSelected,
      tooltip: tooltip,
      position: PopupMenuPosition.over,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      itemBuilder: (BuildContext context) {
        return dropdownItems.map((item) {
          int index = dropdownItems.indexOf(item);
          return PopupMenuItem<int>(
            value: index,
            child: ListTile(
              leading: Icon(item.icon),
              trailing: Text(item.text),
            )
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SvgPicture.asset(
          iconName,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}

class _PopupMenuItemData {
  String text;
  IconData icon;

  _PopupMenuItemData(this.text, this.icon);
}