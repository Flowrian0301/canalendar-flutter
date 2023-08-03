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
  UserDropdown? appBarUserDropdown;
  @override
  void initState() {
    super.initState();
    appBarUserDropdown = UserDropdown(color: Colors.white,);
    SaveData.load();
    if (appBarUserDropdown != null && appBarUserDropdown!.updateUserListCallback != null) appBarUserDropdown!.updateUserListCallback!();
    if (SaveData.getUserNames().isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => PopupUtil.openRegisterUserAlert(context, isDismissable: false,
          onUpdateUserList: () {
            appBarUserDropdown?.updateUserListCallback!();
            SaveData.save();
          })
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: appBarUserDropdown
      ),
      drawer: Drawer(
        child: ListView(
          children: [
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
                PopupUtil.openRegisterUserAlert(context, onUpdateUserList: () {
                  appBarUserDropdown?.updateUserListCallback!();
                  SaveData.save();
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.person_remove),
              title: Text(localization.delete_user),
              onTap: () {
                Navigator.pop(context);
                PopupUtil.openDeleteUserAlert(context, onUpdateUserList: () {
                  appBarUserDropdown?.updateUserListCallback!();
                  SaveData.save();
                  if (SaveData.getUserNames().isEmpty) {
                    PopupUtil.openRegisterUserAlert(context, onUpdateUserList: () {
                      appBarUserDropdown?.updateUserListCallback!();
                      SaveData.save();
                    });
                  }
                });
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
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          children: <Widget>[
            Expanded(
              child: CalendarView()
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: FloatingActionBar(),
            )
          ],
        ),
      ),
    );
  }
}
