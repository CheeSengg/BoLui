//Packages
import 'package:flutter/material.dart';
import 'package:bolui/util/auth.dart';
import 'package:bolui/util/currency_input_formatter.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signedOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  TextEditingController _textFieldController = TextEditingController();

  //Configurations for Alert Text Box
  _setBudget(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Key in your Budget'),
            content: TextField(
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                new CurrencyInputFormatter(),
              ],
              keyboardType: TextInputType.number,
              controller: _textFieldController,
              decoration: InputDecoration(hintText: 'Key in your Budget'),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('ENTER'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'SETTING',
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: buildInputs(context));
  }

  Widget buildInputs(BuildContext context) {
    return ListView(
      children: <Widget>[
        setBudget(context),
        Divider(),
        signOut(),
        Divider(),
      ],
    );
  }

  Widget signOut() {
    return ListTile(
      onTap: _signedOut,
      title: Text(
        'LOG OUT',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget setBudget(BuildContext context) {
    return ListTile(
      onTap: () => _setBudget(context),
      title: new Text(
        'Set Budget',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class PiChart extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Center(
          child: Text(
        "Settings",
        style: TextStyle(
          fontSize: 30,
          color: Colors.black,
        ),
      )),
    );
  }
}

class Spending extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(padding: EdgeInsets.all(20)),
          _redBox(),
          Container(padding: EdgeInsets.all(5)),
          Text('Spendings ', style: TextStyle(fontSize: 16, color: Colors.red)),
          Text('Amount ', style: TextStyle(fontSize: 16, color: Colors.red)),
        ],
      ),
    );
  }

  Widget _redBox() {
    return Container(
      decoration: BoxDecoration(color: Colors.red),
      child: Icon(Icons.crop_square, color: Colors.red),
    );
  }
}

class RemainingBudget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(padding: EdgeInsets.all(20)),
          _greenBox(),
          Container(padding: EdgeInsets.all(5)),
          Text('Remaining ',
              style: TextStyle(fontSize: 16, color: Colors.green)),
          Text('Amount ', style: TextStyle(fontSize: 16, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _greenBox() {
    return Container(
      decoration: BoxDecoration(color: Colors.green),
      child: Icon(Icons.crop_square, color: Colors.green),
    );
  }
}

class Transactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
        "A",
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontSize: 10,
          color: Colors.black,
        ),
      )),
    );
  }
}
