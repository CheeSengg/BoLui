//Packages
import 'package:bolui/util/EntryPopup.dart';
import 'package:flutter/cupertino.dart';
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
  _generateData() {
    var sampleData = [
      new PiData('Spending', 100.0, Colors.blue),
      new PiData('Remaining', 50.0, Colors.blueAccent)
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
    _createSampleData = List<charts.Series<PiData, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.add),
            onPressed: () async {
              final String currentTeam = await entryPopup(context);
            },
          ),
        ],
      ),
      body: scrollingView(),
    );
  }

  // Configurations for Container size of the PiChart
  // Configurations for the Text in the middle of PiChart
  Widget donutPi() {
    return Container(
      height: 300,
      child: Stack(
        children: <Widget>[
          PiChart(_createSampleData),
          Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 120)),
              Center(
                child: Text(
                  'Hi There',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, color: Colors.green),
                ),
              ),
              Center(
                child: Text(
                  'This is the Second line',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.redAccent,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  //Configurations for ListView of the different spending entries
  Widget spendingCategories() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.amber[600],
          child: const Center(child: Text('Entry A')),
        ),
        Container(
          height: 50,
          color: Colors.amber[500],
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          height: 50,
          color: Colors.amber[100],
          child: const Center(child: Text('Entry C')),
        ),
        Container(
          height: 50,
          color: Colors.amber[100],
          child: const Center(child: Text('Entry D')),
        ),
        Container(
          height: 50,
          color: Colors.amber[100],
          child: const Center(child: Text('Entry E')),
        ),
      ],
    );
  }

  //Configurations for the Scrolling View
  Widget scrollingView(){
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: donutPi(),
              ),
              expandedHeight: 300.0,
            )
          ];
        },
        body: spendingCategories()
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

//Parameters to create the PiChart
class PiData {
  final String item;
  final double expenditure;
  final Color colorVal;

  PiData(this.item, this.expenditure, this.colorVal);
}
