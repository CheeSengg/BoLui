import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PiChart extends StatefulWidget{
  PiChart({this.budget});
  final double budget;
  @override
  State<StatefulWidget> createState() => new _PiChartState();
}

class _PiChartState extends State<PiChart> {
  List<charts.Series<PiData, String>> _createSampleData;

  _generateData() {
    //added the following two lines + caused error
    var sampleData = [
      new PiData('Spending', 100.0, Colors.blue[300]),
      new PiData('Remaining', widget.budget, Colors.lightBlue[100]) //changed the value here to reflect budget.
    ];

    _createSampleData.add(
      charts.Series(
          id: 'Chart Name',
          data: sampleData,
          domainFn: (PiData piData, _) =>
          piData.item + " " + piData.expenditure.toStringAsFixed(2),
          measureFn: (PiData piData, _) => piData.expenditure,
          colorFn: (PiData piData, _) =>
              charts.ColorUtil.fromDartColor(piData.colorVal)),
    );
  }

  @override
  void initState() {
    super.initState();
//      _createSampleData = List<charts.Series<PiData, String>>();
//      _generateData();
  }

  @override
  Widget build(BuildContext context){
    _createSampleData = List<charts.Series<PiData, String>>();
    _generateData();
    return Container(
      height: 300,
      child: Stack(
        children: <Widget>[
          _buildPiChart(),
          Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 120)),
              Center(
                child: new Text(
                  '\$50.00',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.black,
                  ),
                ),
              ),
              Center(
                child: const Text(
                  'Left to spend',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPiChart() {
    return new charts.PieChart(
      _createSampleData,
      animate: true,
      animationDuration: Duration(milliseconds: 500),
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 20,
      ),
    );
  }
}

//Parameters to create the PiChart
class PiData {
  final String item;
  final double expenditure;
  final Color colorVal;

  PiData(this.item, this.expenditure, this.colorVal);
}
