import 'package:flutter/material.dart';

class userInfo extends InheritedWidget {
  final userId;
  var monthlyAmount;

  userInfo({Key key, @required this.userId, @required Widget child}) : assert(child != null), super(key: key, child: child);

  static String of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(userInfo) as userInfo).userId;
  }

  @override
  bool updateShouldNotify(old) {
    return true;
  }
}
