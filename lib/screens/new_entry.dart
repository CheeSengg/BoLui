import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:bolui/util/currency_input_formatter.dart';
import 'package:bolui/models/auth_provider.dart';
import 'package:bolui/util/auth.dart';

class EntryPage extends StatefulWidget {
  EntryPage({this.updateField, this.docID, this.day});
  final bool updateField;
  final String docID;
  final int day;

  @override
  _EntryPage createState() {
    return _EntryPage();
  }
}

//TODO: include time based entry
class _EntryPage extends State<EntryPage> {
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String description;
  String category;
  double amount;
  String yearMonth;

  //Hardcoded Data
  List<CategoryButton> choices = const <CategoryButton>[
    const CategoryButton(title: 'Leisure', icon: Icons.movie),
    const CategoryButton(title: 'Food', icon: Icons.fastfood),
    const CategoryButton(title: 'Transport', icon: Icons.train),
    const CategoryButton(title: 'Household', icon: Icons.home),
    const CategoryButton(title: 'Others', icon: Icons.local_grocery_store),
  ];
  String selected;

  //function to add items into list

  @override
  void initState() {
    category = "Others";
    super.initState();
    yearMonth =
        DateTime.now().year.toString() + "_" + DateTime.now().month.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Entry'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: new Form(
          key: _formKey,
          child: new ListView(
            primary: true,
            children: buildInputs(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      Padding(
        padding: EdgeInsets.only(bottom: 20),
      ),
      numberField('00.00'),
      Padding(
        padding: EdgeInsets.only(bottom: 20),
      ),
      inputBox('Description'),
      Padding(
        padding: EdgeInsets.only(bottom: 20),
      ),
      Container(child: categorySelection()),
      Padding(
        padding: EdgeInsets.only(bottom: 20),
      ),
      button()
    ];
  }

  Widget categorySelection() {
    return Container(
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(choices.length, (index) {
          return Center(
            child: Card(
                color: category == choices[index].title ? Colors.blue : Colors.white,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      category = choices[index].title;
                    });
                  },
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                            choices[index].icon,
                            color: category == choices[index].title ? Colors.white : Colors.black38,
                            size: 50.0),
                        Text(
                          choices[index].title,
                          style: TextStyle(
                            color: category == choices[index].title ? Colors.white : Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        }),
      ),
    );
  }

  // Configurations for textInputField
  Widget inputBox(String hintText) {
    return new TextFormField(
      decoration: InputDecoration(
        //contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        hintText: hintText,
        //fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please do not leave it empty';
        }
      },
      onSaved: (value) => description = value,
    );
  }

  // Configurations for numberInputField
  Widget numberField(String hintText) {
    return new TextFormField(
      // textAlign: TextAlign.center,
      style: TextStyle(fontSize: 50.0),
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        new CurrencyInputFormatter(),
      ],
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        hintText: hintText,
        //   fillColor: Colors.grey[300],
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
    if(widget.updateField == false){
      return new RaisedButton(
        onPressed: createData,
        child: Text(
            'Add',
            style: TextStyle(color: Colors.white)
        ),
        color: Colors.green,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Expanded(
          child: RaisedButton(
            onPressed: updateData,
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
          ),
        ),
        new Expanded(
          child: RaisedButton(
            onPressed: deleteData,
            child: Text(
             'Delete',
             style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  void createData() {
    final BaseAuth auth = AuthProvider.of(context).auth;
    print(auth.uid());
    //added year and month separately, any better way?
    var day = DateTime.now().day;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      db.collection(auth.uid()).document(yearMonth).collection('log').add({
        'description': description,
        'category': category,
        'amount': amount,
        'day': day,
      });
      Navigator.pop(context);
    }
  }

  void updateData(){
    final BaseAuth auth = AuthProvider.of(context).auth;

    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      db.collection(auth.uid())
          .document(yearMonth)
          .collection('log')
          .document(widget.docID)
          .updateData({
        'description': description,
        'category': category,
        'amount': amount,
        'day': widget.day
      });
      Navigator.pop(context);
    }
  }

  void deleteData() {
    final BaseAuth auth = AuthProvider
        .of(context)
        .auth;

    db.collection(auth.uid())
        .document(yearMonth)
        .collection('log')
        .document(widget.docID)
        .delete();
    Navigator.pop(context);
  }
}

class CategoryButton {
  const CategoryButton({this.title, this.icon});

  final String title;
  final IconData icon;
}
