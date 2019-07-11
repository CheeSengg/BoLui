//Packages
import 'package:bolui/screens/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Imports from own app
import 'screens/home_page.dart';
import 'screens/settings_page.dart';
import 'screens/login_page.dart';
import 'util/auth.dart';
import 'models/combined_model.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CombinedModel>(
      builder: (context) => CombinedModel(),
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Color.fromRGBO(58, 66, 86, 1.0)
        ),
        debugShowCheckedModeBanner: false,
        home: RootPage(auth: Auth()),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});
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
    _storeUID();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
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

  void _storeUID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final model = Provider.of<CombinedModel>(context);
    model.loginUser(user.uid);
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
              body: new HomePage(auth: widget.auth, onSignedOut: _signedOut,),
              bottomNavigationBar: buildNavigationBar(),
            );

          case 1:
          //add auth here?
            return Scaffold(
              body: new TransactionsPage(),
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
        navigationBarItem(Icons.account_balance, 'Transactions')
      ],
    );
  }

  // Configuration for the BottomNavigationBarItem
  BottomNavigationBarItem navigationBarItem(IconData icon, String text) {
    return BottomNavigationBarItem(icon: new Icon(icon), title: new Text(text));
  }
}


