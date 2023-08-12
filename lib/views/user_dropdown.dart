import 'package:canalendar/models/persistency/save_data.dart';
import 'package:flutter/material.dart';

class UserDropdown extends StatefulWidget {
  final Function? openRegisterUserAlert;
  Function? updateUserListCallback;
  final Color? color;

  UserDropdown({Key? key, this.color, this.openRegisterUserAlert}) : super(key: key);

  @override
  _UserDropdownState createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {

  void setCurrentUser(int index) => setState(() {
    SaveData.setCurrentUserIndex(index);
  });

  @override
  Widget build(BuildContext context) {
    TextStyle? style = widget.color == null
      ? Theme.of(context).textTheme.titleSmall
      : Theme.of(context).textTheme.titleSmall!.copyWith(color: widget.color);

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ValueListenableBuilder(
          valueListenable: SaveData.userNames,
          builder: (context, names, child) {
            return DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  iconEnabledColor: widget.color,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  hint: Text(
                    SaveData.currentUser.value == null
                        ? ''
                        : SaveData.currentUser.value!.name!,
                    style: style,
                  ),
                  value: SaveData.currentUserIndex.value,
                  onChanged: (index) {
                    setCurrentUser(index!);
                  },
                  items: names.map((item) {
                    int index = names.indexOf(item);
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                )
            );
          }
        )
    );
  }
}
