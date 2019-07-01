//Packages
import 'package:bolui/screens/root_page.dart' as prefix0;
import 'package:flutter/material.dart';

//Imports from own app
import 'screens/settings_page.dart';
import 'screens/root_Page.dart';
import 'util/auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor:  Colors.cyan[100],
      ),
      debugShowCheckedModeBanner: false,
      home: RootPage(auth: Auth()),
    );
  }
}


