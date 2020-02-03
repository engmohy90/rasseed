import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rasseed/functions/Translations.dart';
import 'package:rasseed/screens/Home_screen.dart';
import 'package:rasseed/screens/login_screens/Login_with_flip.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'functions/app_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  Widget nextWidget;

  @override
  void initState() {
    super.initState();

    get_auth().then(
      (loggedIn) => setState(
        () {
          loggedIn != null ? isLoggedIn = loggedIn : isLoggedIn = false;
          // display the appropriate ui widget
          isLoggedIn
              ? setState(() => nextWidget = Home_screen())
              : setState(
                  () => nextWidget = FlipPage(),
                );
        },
      ),
    );
  }

  Future<bool> get_auth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("client_auth") != null && prefs.getString("client_auth") != "123";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      localizationsDelegates: [
        const TranslationsDelegate(),
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(fontFamily: 'Roboto'),
      home: nextWidget /*client_auth.isNotEmpty ? Home_screen() : FlipPage()*/,
    );
  }
}
