import 'package:flutter/material.dart';

Future<String> entryPopup (BuildContext context) async {
  String teamName = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter New Spending'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Amount', hintText: '4.00'),
                  onChanged: (value) {
                    teamName = value; //Use this to input data
                  },
                ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop(teamName);
            },
          ),
        ],
      );
    },
  );
}