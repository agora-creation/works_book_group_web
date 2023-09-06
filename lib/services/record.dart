import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_group_web/common/functions.dart';
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

  Future<List<RecordModel>> selectList({
    required String? groupNumber,
    required String userId,
    required DateTime searchStart,
    required DateTime searchEnd,
  }) async {
    List<RecordModel> ret = [];
    Timestamp startAt = convertTimestamp(searchStart, false);
    Timestamp endAt = convertTimestamp(searchEnd, true);
    await firestore
        .collection(collection)
        .where('groupNumber', isEqualTo: groupNumber ?? 'error')
        .where('userId', isEqualTo: userId)
        .orderBy('startedAt', descending: false)
        .startAt([startAt])
        .endAt([endAt])
        .get()
        .then((value) {
          for (DocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
            ret.add(RecordModel.fromSnapshot(doc));
          }
        });
    return ret;
  }
}
