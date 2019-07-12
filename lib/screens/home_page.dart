//Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bolui/util/auth.dart';
import 'new_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bolui/util/pi_chart.dart';
import 'package:bolui/util/currency_input_formatter.dart';
import '../models/combined_model.dart';
import 'package:bolui/util/database_service.dart';
import 'package:bolui/models/category_list.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth,this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = Firestore.instance;
  final database = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  double budget;
  String date;


  // Random data for testing
  final List<String> entries = <String>['Entertainment', 'Food', 'Grocery', 'Transport', 'Others'];
  List<charts.Series<PiData, String>> _createSampleData;

  // Hardcoded trial data (can be deleted)
  _generateData() {
    //added the following two lines + caused error
    var sampleData = [
      new PiData('Spending', 100.0, Colors.blue[300]),
      new PiData('Remaining', 50.0, Colors.lightBlue[100]) //changed the value here to reflect budget.
    ];

    _createSampleData.add(
      charts.Series(
          id: 'Chart Name',
          data: sampleData,
          domainFn: (PiData piData, _) =>
          piData.item + " " + piData.expenditure.toStringAsFixed(2),
          measureFn: (PiData piData, _) => piData.expenditure,
          colorFn: (PiData piData, _) =>
              charts.ColorUtil.fromDartColor(piData.colorVal)),
    );
  }

  void _setBudget() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user.uid.toString());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      db.collection(user.uid).document(date).setData({
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
    _createSampleData = List<charts.Series<PiData, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
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
        onTap: widget.onSignedOut,
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
        body: spendingCategories());
  }

  //Widget tree for all components
  Widget collapseWindow() {
    return Column(
      children: <Widget>[
        donutPi(),
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
  Widget donutPi() {
    return Container(
      height: 300,
      child: Stack(
        children: <Widget>[
          PiChart(seriesList: _createSampleData),
          Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 120)),
              Center(
                child: new Text(
                  '\$50.00',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.black,
                  ),
                ),
              ),
              Center(
                child: const Text(
                  'Left to spend',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  //Configurations for ListView of the different spending entries
  Widget spendingCategories() {
    var model = Provider.of<CombinedModel>(context);
    return StreamProvider<List<Entry>>.value(
        value: database.streamCategory(model.user.uid, date),
        child: CategoryList(),
    );
  }
}
