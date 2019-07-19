import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bolui/models/combined_model.dart';
import 'package:date_format/date_format.dart';

class RecentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransactionPageState();
  }
}

class _TransactionPageState extends State<RecentPage> {
  final db = Firestore.instance;
  String date;
  var currDate = DateTime.now().day;
  String currMonth = formatDate(DateTime.now(), [MM]);

  @override
  void initState() {
    super.initState();
    date =
        DateTime.now().year.toString() + "_" + DateTime.now().month.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  child: new Text(
                'Hello there, you have spent too much money today',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              )),
            ),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var entries = Provider.of<List<Entry>>(context) ?? List();
    var reversedEntries = entries.reversed.toList();
    var runningDate = currDate;
    print(runningDate);

    return new ListView.builder(
      itemCount: reversedEntries.length,
      itemBuilder: (context, index) {
        if (runningDate == reversedEntries[index].day) {
          runningDate--;
          print(runningDate);
          return new Column(
            children: <Widget>[
              _buildDateTile(context, reversedEntries[index]),
              _buildEntryTile(context, reversedEntries[index]),
            ],
          );
        } else {
          while (runningDate > reversedEntries[index].day) {
            runningDate--;
          }
          return _buildEntryTile(context, reversedEntries[index]);
        }
      },
    );
  }

  Widget _buildDateTile(BuildContext context, Entry entry) {
    print('build date tile');
    return Container(
      decoration: new BoxDecoration(
        color: Colors.black12,
        border: new Border.all(color: Colors.black26),
      ),
      child: new ListTile(
        title: Text((currDate == entry.day)
            ? 'Today'
            : (currDate - 1 == entry.day)
                ? 'Yesterday'
                : entry.day.toString() +
                    ' ' +
                    currMonth),
      ),
    );
  }

  Widget _buildEntryTile(BuildContext context, Entry entry) {
    return new ListTile(
      title: Text(entry.description),
      subtitle: Text(entry.category),
      trailing: Text(entry.amount.toStringAsFixed(2)),
    );
  }
}
