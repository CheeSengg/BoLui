//Packages
import 'package:bolui/models/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bolui/util/auth.dart';
import 'new_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import 'package:bolui/util/pi_chart.dart';
import 'package:bolui/util/currency_input_formatter.dart';
import '../models/combined_model.dart';
import 'package:bolui/models/category_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final db = Firestore.instance;
  double budget = 0;
  String date;

  // Random data for testing
  final List<String> entries = <String>['Entertainment', 'Food', 'Grocery', 'Transport', 'Others'];

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
    } catch (e) {
      print(e);
    }
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



  @override
  void initState() {
    super.initState();
    date = DateTime.now().year.toString() + '_' + DateTime.now().month.toString();
  }

  Widget build(BuildContext context) {
    var entry = Provider.of<Entry>(context) ?? Entry();
    if(entry.amount != null) budget = entry.amount;
    print("help me see the light please $budget");
    return Scaffold(
      drawer: SizedBox(
        width: 180,
        child: Drawer(
          child: ListView(
            children: _buildSettings(context),
          ),
        ),
      ),
      appBar: AppBar(
        title: Center(child: Text('Stats')),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new EntryPage()),
              );
            },
          ),
        ],
      ),
      body: scrollingView(),
    );
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
        title: Text('LOG OUT', style: TextStyle(fontSize: 16),),
        onTap: () => _signOut(context),
      ),
    ];
  }

  void _setBudgetForm(BuildContext context){
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set your budget', style: TextStyle(fontSize: 24),),
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

  //Configurations for the Scrolling View
  Widget scrollingView() {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: collapseWindow(),
              ),
              expandedHeight: 350.0,
            )
          ];
        },
        body: CategoryList());
  }

  //Widget tree for all components
  Widget collapseWindow() {
    return Column(
      children: <Widget>[
        PiChart(budget: this.budget,),
        Divider(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                '  SPENDING',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              new Text(
                '\$100.00' + "  ",
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Configurations for Container size of the PiChart
  // Configurations for the Text in the middle of PiChart


}
