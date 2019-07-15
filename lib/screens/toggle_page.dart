import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:bolui/models/auth_provider.dart';

import 'package:bolui/screens/transactions_page.dart';
import 'package:bolui/screens/home_page.dart';
import 'package:bolui/util/database_service.dart';
import 'package:bolui/util/auth.dart';
import 'package:bolui/models/combined_model.dart';

class TogglePage extends StatefulWidget {
  TogglePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() {
    return _TogglePageState();
  }
}

class _TogglePageState extends State<TogglePage> {
  var currentTab = 0;
  final database = DatabaseService();
  final date = DateTime.now().year.toString() + "_" + DateTime.now().month.toString();

  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;
    return MultiProvider(
      providers: [
        StreamProvider<List<Entry>>.value(
            value: database.streamCategory(auth.uid(), date)),
        StreamProvider<Entry>.value(
            value: database.streamBudget(auth.uid(), date))
      ],
      child: _buildPage(),
    );
  }

  _buildPage() {
    switch (currentTab) {
      case 0:
        return _buildHomePage();

      case 1:
        //add auth here?
        return _buildTransactionPage();
    }
  }

  Widget _buildHomePage() {
    return Scaffold(
      body: new HomePage(),
      bottomNavigationBar: buildNavigationBar(),
    );
  }

  Widget _buildTransactionPage() {
    return Scaffold(
      body: new TransactionsPage(),
      bottomNavigationBar: buildNavigationBar(),
    );
  }

  // Configurations for NavigationBar Items
  Widget buildNavigationBar() {
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
