import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TransactionsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _TransactionPageState();
  }
}

class _TransactionPageState extends State<TransactionsPage>{
  final db = Firestore.instance;
  String userID;

  @override
  void initState() {
    super.initState();
  }

//  _createSnapshot() async {
//    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    print(user.uid.toString() + " hi this is a test");
//
//    return ;
//  }

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
    return new StreamBuilder(
      stream: Firestore.instance.collection('CxdKw2TK7INi5B1CJzgt6Dbsv7n1')
          .orderBy('day', descending: false)
          .where('month', isEqualTo: DateTime.now().month)
          .where('year', isEqualTo: DateTime.now().year)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return new ListView(
          children: snapshot.data.documents.map((document){
            return new ListTile(
              title: Text(document['description'].toString()),
              subtitle: Text(document['category'].toString()),
              trailing: Text(document['amount'].toString()),
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