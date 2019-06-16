//Packages
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


//class HomePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          PiChart(),
//          Spending(),
//          RemainingBudget(),
//        ],
//      ),
//    );
//  }
//}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final mockedData = [
    new LinearSales(0, 100),
    new LinearSales(1, 75),
    new LinearSales(2, 50),
    new LinearSales(3, 100),
  ];

  List<charts.Series<LinearSales, int>> _createSampleData(
      List<LinearSales> data) {
    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: PiChart(_createSampleData(mockedData))
    );
  }
}


class PiChart extends StatelessWidget {
  final List<charts.Series> seriesList; //List to store values of the chart
  final bool animate; //animation of the chart

  PiChart(this.seriesList, {this.animate = true});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate
    );
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}


//class PiChart extends StatelessWidget {
//  Widget build(BuildContext context) {
//    return Container(
//      height: 400,
//      child: Center(
//          child: Text("Hi",
//            style: TextStyle(
//              fontSize: 30,
//              color: Colors.black,
//            ),
//          )
//      ),
//    );
//  }
//}

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

