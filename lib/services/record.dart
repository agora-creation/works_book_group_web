import 'package:cloud_firestore/cloud_firestore.dart';

class RecordService {
  String collection = 'record';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList(String? groupNumber) {
    return firestore
        .collection(collection)
        .where('groupNumber', isEqualTo: groupNumber ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
