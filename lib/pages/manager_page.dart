import 'package:canalendar/pages/calendar_page.dart';
import 'package:canalendar/pages/map_page.dart';
import 'package:flutter/cupertino.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({super.key});

  @override
  State<StatefulWidget> createState() => _ManagerPageState();

}

class _ManagerPageState extends State<ManagerPage> {
  bool map = false;

  void setPage(bool map) => setState(() => this.map = map);

  @override
  Widget build(BuildContext context) {
    /*if (map) {
      return MapPage();
    } else {*/
      return CalendarPage(onChangePage: (map) => setPage(map));
    //}
  }

}