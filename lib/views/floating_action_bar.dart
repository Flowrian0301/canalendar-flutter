import 'package:canalendar/enumerations/session_type.dart';
import 'package:canalendar/utils/icon_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FloatingActionBar extends StatelessWidget {
  FloatingActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> btns = [];
    for (SessionType type in SessionType.values) {
      btns.add(createButton(type));
    }
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

  Widget createButton(SessionType type) {
    List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
    return PopupMenuButton(
      onSelected: (index) {
        print(index.toString());
      },
      tooltip: '',
      position: PopupMenuPosition.over,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      itemBuilder: (BuildContext context) {
        return dropdownItems.map((item) {
          int index = dropdownItems.indexOf(item);
          return PopupMenuItem<int>(
            value: index,
            child: Text(item),
          );
        }).toList();
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: SvgPicture.asset(
          IconUtil.getSessionTypeIconPath(type),
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}