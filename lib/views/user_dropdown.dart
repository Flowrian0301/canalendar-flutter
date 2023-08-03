import 'package:canalendar/models/persistency/save_data.dart';
import 'package:flutter/material.dart';

import '../models/persistency/user.dart';

class UserDropdown extends StatelessWidget {
  final ValueNotifier<List<String>> _users = ValueNotifier([]);
  final ValueNotifier<int> _selectedUser = ValueNotifier(0);
  final Function? openRegisterUserAlert;

  UserDropdown({Key? key, this.openRegisterUserAlert}) : super(key: key);

  void updateUserList() {
    _users.value = SaveData.getUserNames();
  }

  void setCurrentUser(int index) {
    SaveData.instance!.setCurrentUserIndex(index);
    _selectedUser.value = index;
  }

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
