import 'package:canalendar/models/persistency/save_data.dart';
import 'package:canalendar/utils/popup_util.dart';
import 'package:canalendar/views/calendar_view.dart';
import 'package:canalendar/views/floating_action_bar.dart';
import 'package:canalendar/views/user_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const CanalendarApp());
}

class CanalendarApp extends StatelessWidget {
  const CanalendarApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canalendar',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calendar'),
    );
  }


}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    FloatingActionBar floatingActionBar = FloatingActionBar(calendar!.updateSelectedDay);

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
