
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EntryPage extends StatefulWidget {
  @override
  _EntryPage createState() {
    return _EntryPage();
  }
}
//TODO: include time based entry
class _EntryPage extends State<EntryPage> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String category;
  double amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Entry'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: new Form(
            key: _formKey,
            child: new Column(
              children: buildInputs(),
          ),
        ),
      ),
    );
  }


  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Name',
          fillColor: Colors.grey[300],
          filled: true,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please do not leave it empty';
          }
        },
        onSaved: (value) => name = value,
      ),
      new TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Category',
          fillColor: Colors.grey[300],
          filled: true,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please do not leave it empty';
          }
        },
        onSaved: (value) => category = value,
      ),
      new TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Amount',
          fillColor: Colors.grey[300],
          filled: true,
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please do not leave it empty';
          }
        },
        onSaved: (value) => amount = double.parse(value),
      ),
      new RaisedButton(
        onPressed: createData,
        child: Text('Create', style: TextStyle(color: Colors.white)),
        color: Colors.green,
      ),
    ];
  }

  void createData() async {
    print("created data");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      db.collection('Spending').document(user.uid).setData({'name': '$name', 'category': '$category', 'amount': '$amount'});
    //  setState(() => id = ref.documentID); //Success button? close page?
      //print(ref.documentID);
    }
  }
}
