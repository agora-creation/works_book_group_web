import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_group_web/models/user.dart';

class UserService {
  String collection = 'user';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  Future<List<UserModel>> selectList(String? groupNumber) async {
    List<UserModel> ret = [];
    await firestore
        .collection(collection)
        .where('groupNumber', isEqualTo: groupNumber ?? 'error')
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
        ret.add(UserModel.fromSnapshot(doc));
      }
    });
    return ret;
  }
}
