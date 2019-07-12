import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'preference.dart';
import 'user.dart';


class CombinedModel with ChangeNotifier {
  User user;
  double budget;

  final List<String> entries = ['Entertainment','Food', 'Grocery','Transport', 'Others'];
  
  void loginUser(String uid) {
    user = User(uid: uid);
    notifyListeners();
  }
}

class Entry {
  double amount;
  String category;

  Entry({this.amount, this.category});

  factory Entry.fromFirestore(DocumentSnapshot docSnap){
    Map data = docSnap.data;

    return Entry(
      amount: data['amount'],
      category: data['category']
    );
  }
}