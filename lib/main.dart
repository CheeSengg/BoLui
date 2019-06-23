//Packages
import 'package:flutter/material.dart';

//Imports from own app
import 'screens/HomePage.dart';
import 'screens/SettingsPage.dart';
import 'screens/loginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
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
    //LoginPage(),
    HomePage(),
    SettingsPage()
  ];

  final List<String> header = [
    "Home",
    "Settings"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(header[currentTab]),
      ),
      body: list[currentTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() => currentTab = index);
        },
        items: [
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
