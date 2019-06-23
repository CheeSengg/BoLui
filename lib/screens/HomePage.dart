//Packages
import 'package:bolui/util/EntryPopup.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //The Variable that stores all the collection of PiData
  //Should this variable be private? Think there will be data from other dart pages to update this.
  List<charts.Series<PiData, String>> _createSampleData;

  // Hardcoded trial data (can be deleted)
  _generateData(){
    var sampleData = [
      new PiData('Spending', 100.0, Colors.blue),
      new PiData('Remaining', 50.0, Colors.blueAccent)
    ];

    _createSampleData.add(
      charts.Series(
        id: 'Chart Name',
        data: sampleData,
        domainFn: (PiData piData,_) => piData.item + " " + piData.expenditure.toStringAsFixed(2),
        measureFn: (PiData piData,_) => piData.expenditure,
        colorFn: (PiData piData,_) => charts.ColorUtil.fromDartColor(piData.colorVal)
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    _createSampleData = List<charts.Series<PiData, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            //PiChart Widget
            donutPi(),
            floatingActionBar(),
//            ListView(),
          ],
        ),
      ),
    );
  }

  // Configurations for Container size of the PiChart
  Widget donutPi(){
    return Container(
        height: 300,
        child: Stack(children: <Widget>[
          PiChart(_createSampleData),
          Column(
            children: <Widget>[
              Expanded(
                child: Center(
                    child: )),
          ],),
        ],)
    );
  }

  // Configurations for Floating Action Bar
  Widget floatingActionBar(){
    return Align(
      alignment: FractionalOffset(0.9, 0.6),
      child: FloatingActionButton( //Activates method called entry popup
        onPressed: () async {
          final String currentTeam = await entryPopup(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}

// Configurations for the design of the PiChart
class PiChart extends StatelessWidget {
  final List<charts.Series> seriesList; //List to store values of the chart

  PiChart(this.seriesList);

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: true,
      animationDuration: Duration(seconds: 2),
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 10,
      ),
    );
  }
}

class PiData {
  final String item;
  final double expenditure;
  final Color colorVal;

  PiData(this.item, this.expenditure, this.colorVal);
}