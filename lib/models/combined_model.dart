import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'preference.dart';
import 'user.dart';


class CombinedModel with ChangeNotifier {
  User user;
  double budget;
  Map<String, double> list = Map();
  
  final List<String> entries = ['Entertainment','Food', 'Grocery','Transport', 'Others'];
  
  void loginUser(String uid) {
    user = User(uid: uid);
    notifyListeners();
  }

  loadBudget(String month, String year) async {
    final date = year + "_" + month;
    print(date);
    DocumentSnapshot docSnap =  await Firestore.instance.collection(user.uid).document(date).get();
    budget = docSnap['budget'] == null ? 0 : docSnap['budget'];
    notifyListeners();
    print(budget);
  }
  
  loadTransaction(String month, String year) {
    final date = year + "_" + month;
    final db = Firestore.instance.collection(user.uid).document(date).collection('log');
    print(user.uid);
    for(var i = 0; i < entries.length; i++) {
      double amount = 0;
          db.where('category', isEqualTo: entries[i]).getDocuments().then((querySnap){
            db.document(querySnap.toString()).get().then((docSnap){
              if(docSnap['amount'] != null) amount += docSnap['amount'];
            });
      });
      list[entries[i]] = amount;

      print(entries[i] + " has " + list[entries[i]].toString() + " amount spent on it");
    }
    
  }
}