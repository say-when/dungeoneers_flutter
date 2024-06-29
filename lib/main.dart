import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:dungeoneers/app/constants.dart';
import 'package:dungeoneers/app/i18n.dart';
import 'package:dungeoneers/providers/system_info.dart';
import 'package:dungeoneers/services/system.dart';
import 'package:dungeoneers/dng_web_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Dungeoneers 2.0 rv:88 (iPad14,9; 17.5)
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
            title: Constants.appTitle,
            theme: CupertinoThemeData(
              primaryColor: Colors.deepPurple,
              primaryContrastingColor: Colors.purple[200],
            ),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            navigatorKey: navigatorKey,
            home: const DungeoneersMain(),
          )
        : MaterialApp(
            title: Constants.appTitle,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: false,
            ),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            navigatorKey: navigatorKey,
            home: const DungeoneersMain(),
          );
  }
}

class DungeoneersMain extends StatelessWidget {
  const DungeoneersMain({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: const DNGWebView(),
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
