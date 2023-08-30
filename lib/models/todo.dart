import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String _id = '';
  String _groupNumber = '';
  String _content = '';
  bool _finished = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupNumber => _groupNumber;
  String get content => _content;
  bool get finished => _finished;
  DateTime get createdAt => _createdAt;

  TodoModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupNumber = map['groupNumber'] ?? '';
    _content = map['content'] ?? '';
    _finished = map['finished'] ?? false;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
