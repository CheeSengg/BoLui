import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/combined_model.dart';


class TransactionsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _TransactionPageState();
  }
}

class _TransactionPageState extends State<TransactionsPage>{
  final db = Firestore.instance;
  String date;
  String userID;


  @override
  void initState() {
    super.initState();
    date = DateTime.now().year.toString() + "_" + DateTime.now().month.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Transactions', style: TextStyle(fontSize: 24),),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    final model = Provider.of<CombinedModel>(context); //create a class called model based on the model class in provider
    print(model.user.uid);
    if(model.user.uid == null) return LinearProgressIndicator();
    return new StreamBuilder(
      stream: Firestore.instance.collection(model.user.uid)
          .document(date)
          .collection('log')
          .orderBy('day', descending: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        print(snapshot.data.documents.length);
        return new ListView(
          children: snapshot.data.documents.map((document){
    return new ListTile(
              title: Text(document['description'].toString()),
              subtitle: Text(document['category'].toString()),
              trailing: Text(document['amount'].toStringAsFixed(2)),
            );
          }).toList(),
        );
      },
    );
  }

//  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//    return ListView(
//      padding: const EdgeInsets.only(top: 20.0),
//      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//    );
//  }
//
//  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
//
//
//    return Padding(
//      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//      child: Container(
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.grey),
//          borderRadius: BorderRadius.circular(5.0),
//        ),
//        child: ListTile(
//          title:
//          subtitle:
//          trailing:
//        ),
//      ),
//    );
//  }
}

//class Record{
//  String category;
//  String description;
//  double amount;
//
//  Record(this.category, this.description, this.amount);
//
//  Record.map(dynamic obj) {
//    this.category = obj['category'];
//    this.description = obj['description'];
//    this.amount = obj['amount'];
//  }
//
//  Record.fromSnapshot(Datasnapshot snapshot)
//}