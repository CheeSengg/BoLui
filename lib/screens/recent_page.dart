import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bolui/models/combined_model.dart';

class TransactionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransactionPageState();
  }
}

class _TransactionPageState extends State<TransactionsPage> {
  final db = Firestore.instance;
  String date;

  @override
  void initState() {
    super.initState();
    date =
        DateTime
            .now()
            .year
            .toString() + "_" + DateTime
            .now()
            .month
            .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    var category = Provider.of<List<Entry>>(context) ?? List();

    return new ListView.builder(
      itemCount: category.length,
      itemBuilder: (context, index) {
        return new ListTile(
          title: Text(category[index].description),
          subtitle: Text(category[index].category),
          trailing: Text(category[index].amount.toStringAsFixed(2)),
        );
      },
    );
  }
}
