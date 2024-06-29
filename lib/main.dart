import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:dungeoneers/app/i18n.dart';
import 'package:dungeoneers/providers/system_info.dart';
import 'package:dungeoneers/services/system.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String userAgent = await System.getUserAgentString();
  String documentDirectory = await System.documentDirectory;
  String libraryDirectory = await System.libraryDirectory;
  String soundsDirectory = await System.soundsDirectory;
  String bundleDirectory = await System.bundleDirectory;
  String tempDirectory = await System.tempDirectory;
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );

  runApp(
    Provider<SystemInfo>(
      create: (_) => SystemInfo(
        userAgent: userAgent,
        documentDirectory: documentDirectory,
        libraryDirectory: libraryDirectory,
        soundsDirectory: soundsDirectory,
        bundleDirectory: bundleDirectory,
        tempDirectory: tempDirectory,
      ),
      child: const DungeoneersApp(),
    ),
  );
}

class DungeoneersApp extends StatelessWidget {
  const DungeoneersApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppTranslations.init(context);
    return Platform.isIOS
        ? CupertinoApp(
            title: 'Dugeoneers',
            theme: CupertinoThemeData(
              primaryColor: Colors.deepPurple,
              primaryContrastingColor: Colors.purple[200],
            ),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            home: const DungeoneersMain(title: 'Dungeoneers'),
          )
        : MaterialApp(
            title: 'Dugeoneers',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: false,
            ),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            home: const DungeoneersMain(title: 'Dungeoneers'),
          );
  }
}

class DungeoneersMain extends StatefulWidget {
  const DungeoneersMain({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<DungeoneersMain> createState() => _DungeoneersMainState();
}

class _DungeoneersMainState extends State<DungeoneersMain> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
