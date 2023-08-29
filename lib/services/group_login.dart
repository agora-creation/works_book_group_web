import 'package:cloud_firestore/cloud_firestore.dart';

class GroupLoginService {
  String collection = 'groupLogin';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamListRequest(
    String? groupNumber,
  ) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('groupNumber', isEqualTo: groupNumber ?? 'error')
        .where('accept', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
