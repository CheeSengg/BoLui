//Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';



import 'package:bolui/util/pi_chart.dart';
import '../models/combined_model.dart';
import 'package:bolui/util/category_list.dart';

class MonthPage extends StatefulWidget {
  @override
  _MonthPageState createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  final db = Firestore.instance;
  double budget = 0;
  double expenditure = 0;
  String date;

  // Random data for testing
  final List<String> entries = <String>['Entertainment', 'Food', 'Grocery', 'Transport', 'Others'];

  @override
  void initState() {
    super.initState();
    date = DateTime.now().year.toString() + '_' + DateTime.now().month.toString();
  }

  Widget build(BuildContext context) {
    var entry = Provider.of<Entry>(context) ?? Entry();
    if(entry.amount != null) budget = entry.amount;

    var entries = Provider.of<List<Entry>>(context) ?? List();
    _generateExpenditure(entries);

    return Scaffold(
      body: scrollingView(),
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
        PiChart(budget: this.budget, expenditure: this.expenditure),
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
                this.expenditure.toStringAsFixed(2) + "  ",
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

  void _generateExpenditure(List<Entry> entries){
    double amount = 0.0;
    entries.forEach((n) => amount += n.amount);
    this.expenditure = amount;
  }
}
