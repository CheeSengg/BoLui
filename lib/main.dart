//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Imports from own app
import 'util/auth.dart';
import 'models/combined_model.dart';
import 'package:bolui/screens/root_page.dart';


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

