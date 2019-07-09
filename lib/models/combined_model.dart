import 'package:flutter/material.dart';

import 'preference.dart';
import 'user.dart';


class CombinedModel with ChangeNotifier {
  User user;
  Preferences preference;

  void loginUser(String uid) {
    user = User(uid: uid);
    notifyListeners();
  }

}