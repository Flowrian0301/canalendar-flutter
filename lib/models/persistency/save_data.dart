import 'dart:convert';
import 'dart:io';

import 'package:canalendar/enumerations/stock_type.dart';
import 'package:canalendar/models/persistency/user.dart';
import 'package:canalendar/models/session.dart';
import 'package:flutter/material.dart';

class SaveData {
  static SaveData? _instance;
  SaveData? get instance => _instance;
  int get currentUserIndex => users.isEmpty ? -1 : _currentUserIndex;
  set currentUserIndex(int value) => _currentUserIndex = value;
  int _currentUserIndex = 0;

  List<User> users = [];

  static User? get currentUser => _instance!.currentUserIndex < 0 || _instance!.currentUserIndex >= _instance!.users.length
      ? null
      : _instance!.users[_instance!.currentUserIndex];

  static bool get isInstanceSet => _instance != null;

  SaveData();

  void addUser(String name, TimeOfDay daySeparator, {StockType standardType = StockType.weed}) {
    users.add(User.full(name, standardType, daySeparator));
    if (currentUserIndex < 0) currentUserIndex = 0;
  }

  void deleteCurrentUser() {
    if (currentUserIndex >= 0 && currentUserIndex < users.length) {
      users.removeAt(currentUserIndex);
      currentUserIndex = currentUserIndex.clamp(0, users.length -1);
    }
  }

  static void save() {
    if (_instance == null) return;
    String path = "${Directory.current.path}/data.json";
    String output = jsonEncode(_instance);
    File(path).writeAsStringSync(output);
  }

  static void load() {
    try {
      String path = "${Directory.current.path}/data.json";
      File file = File(path);
      if (file.existsSync()) {
        String jsonString = file.readAsStringSync();
        _instance = SaveData.fromJson(json.decode(jsonString));
      } else {
        _instance = SaveData();
      }
    } catch (_) {
      _instance = SaveData();
    }
  }

  static List<String> getUserNames() {
    List<String> userNames = [];
    for (User user in _instance!.users) {
      userNames.add(user.name!);
    }

    return userNames;
  }

  bool addSessionToCurrentUser(Session session, {bool save = true}) {
    if (currentUser == null) return false;

    currentUser!.addSession(session);
    if (save) SaveData.save();
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'currentUserIndex': currentUserIndex,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }

  factory SaveData.fromJson(Map<String, dynamic> json) {
    return SaveData()
      ..currentUserIndex = json['currentUserIndex']
      ..users = (json['users'] as List<dynamic>).map((userData) => User.fromJson(userData)).toList();
  }
}
