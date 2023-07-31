import 'package:canalendar/models/persistency/save_data.dart';
import 'package:flutter/material.dart';

import '../models/persistency/user.dart';

class UserDropdown extends StatelessWidget {
  static ValueNotifier<List<String>> _users = ValueNotifier([]);
  static ValueNotifier<int> _selectedUser = ValueNotifier(0);
  Function? openRegisterUserAlert;

  static void updateUserList(List<User> users) {
    _users.value = SaveData.getUserNames();
  }

  static void setCurrentUser(int index) {
    SaveData.instance!.setCurrentUserIndex(index);
    _selectedUser.value = index;
  }

  UserDropdown({super.key, this.openRegisterUserAlert});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: _selectedUser.value,
      onChanged: (index) {
        setCurrentUser(index!);
      },
      items: _users.value.map((item) {
        int index = _users.value.indexOf(item);
        return DropdownMenuItem<int>(
          value: index,
          child: Text(item),
        );
      }).toList(),
    );
  }

}