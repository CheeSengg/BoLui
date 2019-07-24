import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bolui/models/combined_model.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<List<Entry>> streamCategory(String id, String date) {
    return _db
        .collection(id)
        .document(date)
        .collection('log')
        .orderBy('day', descending: false)
        .snapshots().map((list) =>
        list.documents.map((doc) => Entry.fromFirestore(doc)).toList());
  }

  Stream<Entry> streamBudget(String id, String date){
    return _db
        .collection(id)
        .document(date)
        .snapshots()
        .map((snap) => Entry.fromMap(snap.data));
  }
}