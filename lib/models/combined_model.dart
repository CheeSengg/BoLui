import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  String description;
  int day;
  String ref;

  Entry({this.amount, this.category, this.day, this.description, this.ref});

  factory Entry.fromFirestore(DocumentSnapshot docSnap){
    Map data = docSnap.data;

    return Entry(
      day: data['day'],
      amount: data['amount'],
      category: data['category'],
      description: data['description'],
      ref: docSnap.documentID
    );
  }

  factory Entry.fromMap(Map data) {
    data = data ?? { };
    return Entry(
      category: data['category'] ?? '',
      amount: data['budget'] ?? 0,
      day: data['day'] ?? 0,
      description: data['description'] ?? '',
      ref: null
    );
  }
}