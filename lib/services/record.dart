import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_group_web/models/record.dart';

class RecordService {
  String collection = 'record';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList(String? groupNumber) {
    return firestore
        .collection(collection)
        .where('groupNumber', isEqualTo: groupNumber ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<RecordModel?> select(String? id) async {
    RecordModel? ret;
    await firestore
        .collection(collection)
        .doc(id ?? 'error')
        .get()
        .then((value) {
      ret = RecordModel.fromSnapshot(value);
    });
    return ret;
  }
}
