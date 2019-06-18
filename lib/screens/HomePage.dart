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
      new PiData('Spending', 100.0),
      new PiData('Remaining', 50.0)
    ];

    _createSampleData.add(
      charts.Series(
        data: sampleData,
        domainFn: (PiData piData,_) => piData.item,
        measureFn: (PiData piData,_) => piData.expenditure,
        id: 'Chart Name'
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
            Display('Spending', 100.00, Colors.red),
            Display('Remaining', 50.00, Colors.green)
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
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 100,
      ),
    );
  }
}

// need to check again if this is suppose to be Stateless or Stateful
// also actually can be integrated with the PiChart class.
class Display extends StatelessWidget{
  String item;
  double amount;
  Color colorVal;

  Display(this.item, this.amount, this.colorVal);

  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(padding: EdgeInsets.all(20)),
          _box(),
          Container(padding: EdgeInsets.all(5)),
          Text(item + " ", style: TextStyle(fontSize: 16, color: colorVal)),
          Text(amount.toStringAsFixed(2), style: TextStyle(fontSize: 16, color: colorVal)),
        ],
      ),
    );
  }

  Widget _box() {
    return Container(
      decoration: BoxDecoration(
          color: colorVal
      ),
      child: Icon(Icons.crop_square, color: colorVal),
    );
  }
}

//Configurations for the design of the buttons
//class Buttons extends StatelessWidget {
//  Widget build (BuildContext context){
//    return ;
//  }
//}

// The variables for each slice of Pi
class PiData {
  final String item;
  final double expenditure;

  PiData(this.item, this.expenditure);
}