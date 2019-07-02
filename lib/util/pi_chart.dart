import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PiChart extends StatefulWidget{
  PiChart({this.seriesList});
  final List<charts.Series> seriesList;
  @override
  State<StatefulWidget> createState() => new _PiChartState();
}

class _PiChartState extends State<PiChart> {
  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      widget.seriesList,
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
