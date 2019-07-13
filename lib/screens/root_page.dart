import 'package:bolui/screens/toggle_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bolui/screens/login_page.dart';
import 'package:bolui/util/auth.dart';
import 'package:bolui/models/combined_model.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    _storeModel();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  void _storeModel() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final model = Provider.of<CombinedModel>(context);
    model.loginUser(user.uid);
  }

  @override
  Widget build(BuildContext context){
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );

      case AuthStatus.signedIn:
        return TogglePage(auth: widget.auth, onSignedOut: _signedOut);
    }
    return CircularProgressIndicator();
  }


}


