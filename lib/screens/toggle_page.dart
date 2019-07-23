import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:bolui/models/auth_provider.dart';

import 'package:bolui/screens/recent_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bolui/util/currency_input_formatter.dart';
import 'package:flutter/services.dart';

import 'package:bolui/util/database_service.dart';
import 'package:bolui/util/auth.dart';
import 'package:bolui/models/combined_model.dart';
import 'package:bolui/screens/new_entry.dart';
import 'package:bolui/screens/month_page.dart';

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
        return _buildRecentPage();

      case 1:
        //add auth here?
        return _buildMonthPage();
    }
  }

  //TODO: center it
  Widget _buildRecentPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent'),
        centerTitle: true,
      ),
      drawer: SizedBox(
        width: 180,
        child: Drawer(
          child: ListView(
            children: _buildSettings(context),
          ),
        ),
      ),
      body: new RecentPage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildNavigationBar(),
    );
  }

  Widget _buildMonthPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Month'),
        centerTitle: true,
      ),
      drawer: SizedBox(
        width: 180,
        child: Drawer(
          child: ListView(
            children: _buildSettings(context),
          ),
        ),
      ),
      body: new MonthPage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildNavigationBar(),
    );
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => new EntryPage()),
        );
      },
      tooltip: 'New',
      child: Icon(Icons.add),
      elevation: 1.0,
    );
  }

  // Configurations for NavigationBar Items
  //TODO: make it with the notch shape??
  Widget buildNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentTab,
      onTap: (int index) {
        setState(() {
          currentTab = index;
        });
      },
      iconSize: 22.0,
      items: [
        navigationBarItem(Icons.assessment, 'Recent'),
        navigationBarItem(Icons.account_balance, 'Month')
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();
  final db = Firestore.instance;
  double budget = 0;
  double expenditure = 0;

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  List<Widget> _buildSettings(BuildContext context){
    return [
      const ListTile(
        title: Text('Settings', style: TextStyle(fontSize: 20),),
      ),
      Divider(),
      new ListTile(
          title: Text('Set Budget', style: TextStyle(fontSize: 16),),
          onTap: () {
            _setBudgetForm(context);
          }
      ),
      Divider(),
      new ListTile(
        title: Text('Logout', style: TextStyle(fontSize: 16),),
        onTap: () => _signOut(context),
      ),
    ];
  }

  void _setBudgetForm(BuildContext context){
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('What is your budget for this month?',textAlign: TextAlign.center, style: TextStyle(fontSize: 24, ),),
          content: new Form(
            key: _formKey,
            child: new TextFormField(
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                new CurrencyInputFormatter(),
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                border: InputBorder.none,
                hintText: 'Key in your budget',
                filled: true,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please do not leave it empty';
                }
              },
              onSaved: (value) => budget = double.parse(value),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('OK'),
              onPressed: _setBudget,
            ),
          ],
        );
      },
    );
  }

    void _setBudget() async {
    final BaseAuth auth = AuthProvider.of(context).auth;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      db.collection(auth.uid()).document(date).setData({
        'budget': budget,
      });
      //print(ref.documentID);
      print('data was successfully created');
    }
    Navigator.of(context).pop();
  }


  // Configuration for the BottomNavigationBarItem
  BottomNavigationBarItem navigationBarItem(IconData icon, String text) {
    return BottomNavigationBarItem(icon: new Icon(icon), title: new Text(text));
  }
}


