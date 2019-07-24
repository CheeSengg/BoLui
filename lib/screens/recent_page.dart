import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bolui/models/combined_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bolui/screens/new_entry.dart';

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

  double _generateTodaySpending(BuildContext context) {
    var entries = Provider.of<List<Entry>>(context) ?? List();
    double todaySpending = 0;

    for(int i = 0; i < entries.length; i++){
      if(currDate == entries[i].day) todaySpending += entries[i].amount;
    }

    return todaySpending;
  }

  @override
  void initState() {
    super.initState();
    date =
        DateTime.now().year.toString() + "_" + DateTime.now().month.toString();
  }

  @override
  Widget build(BuildContext context) {
    var todaySpending = _generateTodaySpending(context).toStringAsFixed(2);
    return Scaffold(
      body: Container(
        child: ListView(
          primary: true,
          children: <Widget>[
            new SizedBox(
              height: 200.0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      child: new Text(
                    'Hello, you have spent \$$todaySpending today', //add daily budget
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  )),
                ),
              ),
            ),
            Container(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var entries = Provider.of<List<Entry>>(context) ?? List();
    var runningDate = 1;
    print(runningDate);

    return new ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        while (runningDate < entries[index].day) {
          runningDate++;
        }
        if (runningDate == entries[index].day) {
          runningDate++;
          print(runningDate);
          return new Column(
            children: <Widget>[
              _buildDateTile(context, entries[index]),
              _buildEntryTile(context, entries[index]),
            ],
          );
        } else {
          runningDate++;
          return _buildEntryTile(context, entries[index]);
        }
      },
    );
  }

  Widget _buildDateTile(BuildContext context, Entry entry) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.black12,
        border: new Border.all(color: Colors.black26),
      ),
      child: new ListTile(
        title: Text((currDate == entry.day)
            ? 'Today'
            : (((currDate - 1) == entry.day)
                ? 'Yesterday'
                : entry.day.toString() +
                    ' ' +
                    currMonth)),
      ),
    );
  }

  Widget _buildEntryTile(BuildContext context, Entry entry) {
    return new Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: new ListTile(
        title: Text(entry.description),
        subtitle: Text(entry.category),
        trailing: Text(entry.amount.toStringAsFixed(2)),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => new EntryPage(updateField: true, docID: entry.ref, day: entry.day,)),
            );
          }
        ),
      ],
    );
  }
}
