//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Imports from own app
import 'package:bolui/util/auth.dart';
import 'package:bolui/models/auth_provider.dart';
import 'package:bolui/screens/root_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Color.fromRGBO(58, 66, 86, 1.0)
        ),
        debugShowCheckedModeBanner: false,
        home: RootPage(),
      ),
    );
  }
}

