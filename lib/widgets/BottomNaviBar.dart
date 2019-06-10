import 'package:flutter/material.dart';

class BottomNaviBar extends StatelessWidget{
  Widget build(BuildContext context){
    return BottomNavigationBar(
      currentIndex: 1, // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.calendar_today),
          title: new Text('Calendar'),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.assessment),
          title: new Text('Stats'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings')
        )
      ],
    );
  }
}