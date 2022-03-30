import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('locations');

class FirebaseOperations extends ChangeNotifier {
  Future<void> addItem({
    required double lat,
    required double long,
    required String address,
    required DateTime date,
    required int i,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc("location$i");

    Map<String, dynamic> data = <String, dynamic>{
      "Lat": lat,
      "Long": long,
      "address": address,
      "date": date,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Notes item added to the database"))
        .catchError((e) => print(e));
  }
}
