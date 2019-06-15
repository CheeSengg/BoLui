import 'package:flutter/material.dart';
import 'screens/HomePage.dart';
import 'screens/SettingsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentTab = 0;

  final List<Widget> list = [
    HomePage(),
    SettingsPage(),
    SettingsPage()
  ];

  final List<String> header = [
    "Home",
    "Stats",
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
          BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            title: new Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.assessment),
            title: new Text('Stats'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings'))
        ],
      ),
    );
  }
}
