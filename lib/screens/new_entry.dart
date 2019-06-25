import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
      Padding(padding: EdgeInsets.only(bottom: 10),),
      inputBox('Name', 'Please do not leave it empty'),
      Padding(padding: EdgeInsets.only(bottom: 10),),
      inputBox('Category', 'Please do not leave it empty'),
      Padding(padding: EdgeInsets.only(bottom: 10),),
      new TextFormField(
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          new CurrencyInputFormatter(),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
      Padding(padding: EdgeInsets.only(bottom: 10),),
      new RaisedButton(
        onPressed: createData,
        child: Text('Create', style: TextStyle(color: Colors.white)),
        color: Colors.green,
      ),
    ];
  }

  // Configurations for textInputFields
  Widget inputBox(String hintText, String validator) {
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
          return validator;
        }
      },
      onSaved: (value) => name = value,
    );
  }


  void createData() async {
    print("created data");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      db.collection('Spending').document(user.uid).setData(
          {'name': '$name', 'category': '$category', 'amount': '$amount'});
      Navigator.pop(context);
      //print(ref.documentID);
    }
  }
}

// Configurations for Number display format in Amount field
class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = new NumberFormat("###,###,##0.00", "en_US");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
