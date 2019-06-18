//Packages
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
      new PiData('Spending', 100.0, Colors.red),
      new PiData('Remaining', 50.0, Colors.green)
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
            Expanded(
              child: PiChart(_createSampleData),
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              backgroundColor: Colors.cyan,
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
          ],
        ),
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
      animationDuration: Duration(seconds: 3),
      behaviors: [
        new charts.DatumLegend(
          position: charts.BehaviorPosition.bottom,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(bottom: 4.0),
          entryTextStyle: charts.TextStyleSpec(
            fontFamily: 'Rock Salt',
            fontSize: 20,
          )
        )
      ],
    );
  }
}

class PiData {
  final String item;
  final double expenditure;
  final Color colorVal;

  PiData(this.item, this.expenditure, this.colorVal);
}