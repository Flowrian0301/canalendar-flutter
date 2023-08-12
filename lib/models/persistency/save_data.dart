import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:canalendar/enumerations/stock_type.dart';
import 'package:canalendar/models/persistency/user.dart';
import 'package:canalendar/models/session.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SaveData {
  static List<User> users = [];
  static ValueNotifier<int> currentUserIndex = ValueNotifier(-1);
  static ValueNotifier<List<String>> userNames = ValueNotifier([]);
  static ValueNotifier<User?> currentUser = ValueNotifier(null);

  static void setCurrentUserIndex(int value) {
    currentUserIndex.value = value;
    currentUser.value = value >= 0 ? users[value] : null;
  }

  static void addUser(String name, TimeOfDay daySeparator,
      {StockType standardType = StockType.weed}) {
    users.add(User(name, standardType: standardType, daySeparator: daySeparator));
    _updateUserNames();
    setCurrentUserIndex(currentUserIndex.value < 0 ? 0 : users.length - 1);
    save();
  }

  static void deleteCurrentUser() {
    if (currentUserIndex.value >= 0 && currentUserIndex.value < users.length) {
      users.removeAt(currentUserIndex.value);
      _updateUserNames();
      setCurrentUserIndex(max(-1, currentUserIndex.value - 1));
      save();
    }
  }

  static Future<void> save() async {
    String path = await _localPath;
    String output = jsonEncode(toJson());
    File(path).writeAsStringSync(output);
  }

  static Future<void> load({Function? onLoaded}) async {
    try {
      String path = await _localPath;
      File file = File(path);
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        Map<String, dynamic> jsonData = json.decode(jsonString);

        users = List<User>.from((jsonData['users'] as List<dynamic>).map((userData) => User.fromJson(userData)));
        _updateUserNames();
        setCurrentUserIndex(jsonData['currentUserIndex']);
      }
    } catch (_) {
    }
  }

  static void _updateUserNames() {
    List<String> names = [];
    for (User user in users) {
      names.add(user.name!);
    }
    userNames.value = names;
  }

  static bool addSessionToCurrentUser(Session session, {bool save = true}) {
    if (currentUser.value == null) return false;
    currentUser.value!.addSession(session);
    if (save) SaveData.save();
    return true;
  }

  static Map<String, dynamic> toJson() {
    return {
      'currentUserIndex': currentUserIndex.value,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }



  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/data.json";
  }
}
