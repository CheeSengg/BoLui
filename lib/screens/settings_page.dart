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

