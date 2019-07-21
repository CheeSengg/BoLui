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

  //not sure if this works out.
  deleteData(String id, String date, String category, String description, double amount, int day){
    //query for documentID
    var docID = _db.collection(id)
        .document(date)
        .collection('log')
        .where('day', isEqualTo: day)
        .where('category', isEqualTo: category)
        .where('description', isEqualTo: description)
        .where('amount', isEqualTo: amount)
        .getDocuments();

    print(docID);

    //deletion of document after getting its ID
    _db.collection(id)
        .document(date)
        .collection('log')
        .document(docID.toString())
        .delete().catchError((e) {
          print(e);
    });
  }

}