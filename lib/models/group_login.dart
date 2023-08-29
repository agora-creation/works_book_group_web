import 'package:cloud_firestore/cloud_firestore.dart';

class GroupLoginModel {
  String _id = '';
  String _groupNumber = '';
  String _groupName = '';
  String _userName = '';
  bool _accept = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupNumber => _groupNumber;
  String get groupName => _groupName;
  String get userName => _userName;
  bool get accept => _accept;
  DateTime get createdAt => _createdAt;

  GroupLoginModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupNumber = map['groupNumber'] ?? '';
    _groupName = map['groupName'] ?? '';
    _userName = map['userName'] ?? '';
    _accept = map['accept'] ?? false;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
