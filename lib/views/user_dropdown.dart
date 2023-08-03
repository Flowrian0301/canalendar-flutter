import 'package:canalendar/models/persistency/save_data.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class UserDropdown extends StatefulWidget {
  final Function? openRegisterUserAlert;
  Function? updateUserListCallback;
  final Color? color;

  UserDropdown({Key? key, this.color, this.openRegisterUserAlert}) : super(key: key);

  @override
  _UserDropdownState createState() {
    _UserDropdownState state = _UserDropdownState();
    updateUserListCallback = () => state.updateUserList();
    return state;
  }
}

class _UserDropdownState extends State<UserDropdown> {
  final ValueNotifier<List<String>> _users = ValueNotifier([]);
  final ValueNotifier<int> _selectedUserIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    updateUserList();
  }

  void updateUserList() => setState(() {
      _users.value = SaveData.getUserNames();
      _selectedUserIndex.value = SaveData.instance!.getCurrentUserIndex();
    });


  void setCurrentUser(int index) => setState(() {
    SaveData.instance!.setCurrentUserIndex(index);
    _selectedUserIndex.value = index;
  });

  @override
  Widget build(BuildContext context) {
    /*Color border = widget.color == null
      ? Colors.black.withOpacity(.5)
      : widget.color!.withOpacity(.5);*/
    TextStyle? style = widget.color == null
      ? Theme.of(context).textTheme.titleSmall
      : Theme.of(context).textTheme.titleSmall!.copyWith(color: widget.color);

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          //border: Border.all(color: border),
        ),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              iconEnabledColor: widget.color,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              padding: const EdgeInsets.only(left: 16, right: 8),
              hint: Text(
                _selectedUserIndex.value >= 0
                    ? _users.value[_selectedUserIndex.value]
                    : '',
                style: style,
              ),
              //value: _selectedUserIndex.value,
              onChanged: (index) {
                setCurrentUser(index!);
              },
              items: _users.value.map((item) {
                int index = _users.value.indexOf(item);
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(
                    item,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            )
        )
    );
  }
}
