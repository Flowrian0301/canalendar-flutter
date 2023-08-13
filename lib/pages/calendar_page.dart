import 'package:canalendar/models/persistency/save_data.dart';
import 'package:canalendar/utils/popup_util.dart';
import 'package:canalendar/views/calendar_view.dart';
import 'package:canalendar/views/floating_action_bar.dart';
import 'package:canalendar/views/user_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = 'Calendar';

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarView? calendar;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          SaveData.load().whenComplete(() {
            if (SaveData.userNames.value.isNotEmpty) {
              calendar?.onUserChanged();
            }
            else {
              PopupUtil.openRegisterUserAlert(context, isDismissable: false,
                  onUpdateUserList: () {
                    calendar?.onUserChanged();
                    SaveData.save();
                  }
              );
            }
          });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    calendar = CalendarView();
    FloatingActionBar floatingActionBar = FloatingActionBar(()
    {
      calendar!.updateDayDisplays();
      calendar!.updateMonthAmounts();
    },
      selectedDate: calendar!.selectedDate,
    );

    SaveData.currentUser.addListener(() {
      calendar!.onUserChanged();
    });
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.primary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: UserDropdown(color: Colors.white)
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: UserDropdown()
            ),
            /*UserAccountsDrawerHeader(
              accountName: Text('John Doe'),
              accountEmail: Text('john.doe@example.com'),
              /*currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
              ),*/
            ),*/
            ListTile(
              leading: Icon(Icons.person),
              title: Text(localization.user_info),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text(localization.new_user),
              onTap: () {
                Navigator.pop(context);
                PopupUtil.openRegisterUserAlert(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_remove),
              title: Text(localization.delete_user),
              onTap: () {
                Navigator.pop(context);
                PopupUtil.openDeleteUserAlert(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text(localization.calendar),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(localization.settings),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: calendar!
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: floatingActionBar,
          )
        ],
      ),
    );
  }
}
