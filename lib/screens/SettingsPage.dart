//Packages
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PiChart(),
        ],
      ),
    );
  }
}

class PiChart extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Center(
          child: Text("Settings",
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
            ),
          )
      ),
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
      decoration: BoxDecoration(
          color: Colors.red
      ),
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
      decoration: BoxDecoration(
          color: Colors.green
      ),
      child: Icon(Icons.crop_square, color: Colors.green),
    );
  }
}

class Transactions extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text("A",
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          )
      ),
    );
  }
}

