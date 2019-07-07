//Packages
import 'package:flutter/material.dart';

//Imports from own app
import 'screens/home_page.dart';
import 'screens/settings_page.dart';
import 'screens/login_page.dart';
import 'util/auth.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
//        brightness: Brightness.light,
//        primaryColor: Colors.lightBlue[800],
//        accentColor:  Colors.cyan[100],
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0)
      ),
      debugShowCheckedModeBanner: false,
      home: RootPage(auth: Auth()),
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage(
      {this.auth}); //TODO: What does this mean ah? are the info from here passed out?
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  var currentTab = 0;
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        print(userId);
      });
    });
  }

  void _signedIn() {
    currentTab = 0;
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    currentTab = 0;
    setState(() {
      authStatus = AuthStatus.notSignedIn;
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
        switch (currentTab) {
          case 0:
            return Scaffold(
              body: HomePage(auth: widget.auth, onSignedOut: _signedOut,),
              bottomNavigationBar: buildNavigationBar(),
            );

          case 1:
          //add auth here?
            return Scaffold(
              body: SettingsPage(
                auth: widget.auth,
                onSignedOut: _signedOut,
              ),
              bottomNavigationBar: buildNavigationBar(),
            );
        }
    }
    return null;
  }

  // Configurations for NavigationBar Items
  Widget buildNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentTab,
      onTap: (int index) {
        setState(() {
          currentTab = index;
        });
      },
      items: [
        navigationBarItem(Icons.assessment, 'Home'),
        navigationBarItem(Icons.settings, 'Settings')
      ],
    );
  }

  // Configuration for the BottomNavigationBarItem
  BottomNavigationBarItem navigationBarItem(IconData icon, String text) {
    return BottomNavigationBarItem(icon: new Icon(icon), title: new Text(text));
  }
}


