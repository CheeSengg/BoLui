//Packages
import 'package:bolui/util/EntryPopup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
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

  // Random data for testing
  final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F'];

  // Random data for testing
  final List<IconData> icons = <IconData>[
    Icons.add,
    Icons.assessment,
    Icons.settings,
    Icons.calendar_today,
    Icons.crop_square,
    Icons.favorite
  ];

  // Hardcoded trial data (can be deleted)
  _generateData() {
    var sampleData = [
      new PiData('Spending', 100.0, Colors.blue[300]),
      new PiData('Remaining', 50.0, Colors.lightBlue[100])
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

  //Configurations for the Scrolling View
  Widget scrollingView() {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: collapseWindow(),
              ),
              expandedHeight: 350.0,
            )
          ];
        },
        body: spendingCategories());
  }

  Widget collapseWindow() {
    return Column(
      children: <Widget>[
        donutPi(),
        Divider(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                '  SPENDING',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              new Text(
                '\$100.00' + "  ",
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
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

  //Configurations for ListView of the different spending entries
  Widget spendingCategories() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, left: 8.0),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Icon(icons[index]),
              Padding(padding: EdgeInsets.only(right: 8.0)),
              Expanded(
                child: Text(
                  'Entry ${entries[index]}',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
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
      animationDuration: Duration(milliseconds: 500),
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
