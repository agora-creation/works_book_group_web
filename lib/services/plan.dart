import 'package:cloud_firestore/cloud_firestore.dart';

class PlanService {
  String collection = 'plan';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList(String? groupNumber) {
    return firestore
        .collection(collection)
        .where('groupNumber', isEqualTo: groupNumber ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
