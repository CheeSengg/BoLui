//Packages
import 'package:bolui/screens/root_page.dart' as prefix0;
import 'package:flutter/material.dart';

//Imports from own app
import 'screens/HomePage.dart';
import 'screens/SettingsPage.dart';
import 'screens/loginPage.dart';
import 'screens/root_Page.dart';
import 'util/auth.dart';
import 'screens/new_entry.dart';

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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var currentTab = 0;

  final List<Widget> list = [
    LoginPage(auth: new Auth()),
   // EntryPage(),
    HomePage(),
    SettingsPage()
  ];

  final List<String> header = [
    "Login",
    "Home",
    "Settings"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[currentTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() => currentTab = index);
        },
        items: [
          navigationBarItem(Icons.assessment, 'Login'),
          navigationBarItem(Icons.assessment, 'Home'),
          navigationBarItem(Icons.settings, 'Settings')
        ],
      ),
    );
  }


  // Configuration for the BottomNavigationBarItem
  BottomNavigationBarItem navigationBarItem(IconData icon, String text){return BottomNavigationBarItem(
      icon: new Icon(icon),
      title: new Text(text)
    );
  }
}

