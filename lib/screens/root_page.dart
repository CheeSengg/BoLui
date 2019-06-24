import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bolui/util/auth.dart';
import 'package:bolui/screens/HomePage.dart';
import 'package:bolui/screens/SettingsPage.dart';
import 'package:bolui/screens/loginPage.dart';


class RootPage extends StatefulWidget{
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage>{

  var currentTab = 0;

  final List<Widget> list = [
    HomePage(),
    SettingsPage()
  ];

  final List<String> header = [
    "Home",
    "Settings"
  ];

  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId){
      setState(() {
//        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {

      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );

      case AuthStatus.signedIn:
        return Scaffold(
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
  }


    // Configuration for the BottomNavigationBarItem
  BottomNavigationBarItem navigationBarItem(IconData icon, String text){
    return BottomNavigationBarItem(
        icon: new Icon(icon),
        title: new Text(text)
    );
  }
}