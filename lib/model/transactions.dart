//import 'dart:collection';
//
//import 'package:provider/provider.dart';
//import 'package:flutter/material.dart';
//
//class TransactionModel extends ChangeNotifier {
//  final List<Entry> _entries = [];
//
//  UnmodifiableListView<Entry> get Entry => UnmodifiableListView(_entries);
//
//  void add(Entry entry) {
//    _entries.add(Entry);
//    notifyListeners();
//  }
//}
//
//class Entry {
//  String shopName;
//  double amount;
//  // final vector<tuple> date;
//  String category;
////logo??
//
//  Entry(String shopName, double amount, String category) {
//    this.shopName = shopName;
//    this.amount = amount;
//    this.category = category;
//  }
//}