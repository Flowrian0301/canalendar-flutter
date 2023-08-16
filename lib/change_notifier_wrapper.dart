import 'package:flutter/material.dart';

class ChangeNotifierWrapper extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}