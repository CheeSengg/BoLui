import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:bolui/util/currency_input_formatter.dart';

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

  //Hardcoded Data
  List<DropdownMenuItem<String>> list = [];
  List<String> generateList = ['Entertainment', 'Transport', 'Food', 'Others'];
  String selected;

  //function to add items into list
  //TODO: once the categories have been set write to load a list.
  void loadData() {
    list = [];
    list = generateList
        .map((val) => new DropdownMenuItem(
              child: new Text(val),
              value: val,
            ))
        .toList();

    selected = generateList.last;
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

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
      Padding(
        padding: EdgeInsets.only(bottom: 10),
      ),
      listDrop(),
//      inputBox('Category'),
      Padding(
        padding: EdgeInsets.only(bottom: 10),
      ),
      inputBox('Description'),
      Padding(
        padding: EdgeInsets.only(bottom: 10),
      ),
      numberField('Amount'),
      Padding(
        padding: EdgeInsets.only(bottom: 10),
      ),
      button()
    ];
  }

  Widget listDrop() {
    return Container(
        child: new DropdownButton(
      value: selected,
      items: list,
      onChanged: (value) {
        selected = value;
        category = value;
        setState(() {});
      },
    ));
  }

  // Configurations for textInputField
  Widget inputBox(String hintText) {
    return new TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        hintText: hintText,
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please do not leave it empty';
        }
      },
      onSaved: (value) => name = value,
    );
  }

  // Configurations for numberInputField
  Widget numberField(String hintText) {
    return new TextFormField(
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        new CurrencyInputFormatter(),
      ],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        hintText: hintText,
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
    );
  }

  // Configurations for Button
  Widget button() {
    return new RaisedButton(
      onPressed: createData,
      child: Text('Add', style: TextStyle(color: Colors.white)),
      color: Colors.green,
    );
  }

  void createData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //added year and month separately, any better way?
    var year = DateTime.now().day;
    var month = DateTime.now().month;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      db
          .collection(user.uid)
          .add({'name': '$name', 'category': '$category', 'amount': amount, 'month': '$month', 'year': '$year'});
      Navigator.pop(context);
      //print(ref.documentID);
    }
  }
}


