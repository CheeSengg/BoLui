import 'package:bolui/models/auth_provider.dart';
import 'package:bolui/screens/toggle_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bolui/screens/login_page.dart';
import 'package:bolui/util/auth.dart';
import 'package:bolui/models/combined_model.dart';

class RootPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isLoggedIn = snapshot.hasData;
          return isLoggedIn ? TogglePage(auth: auth) : LoginPage();
        } else {
            return CircularProgressIndicator();
        }
      }
    );
  }
}


