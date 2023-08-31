import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String _id = '';
  String _groupNumber = '';
  String _title = '';
  String _details = '';
  bool _finished = false;
  String _createdUser = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupNumber => _groupNumber;
  String get title => _title;
  String get details => _details;
  bool get finished => _finished;
  String get createdUser => _createdUser;
  DateTime get createdAt => _createdAt;

  TodoModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupNumber = map['groupNumber'] ?? '';
    _title = map['title'] ?? '';
    _details = map['details'] ?? '';
    _finished = map['finished'] ?? false;
    _createdUser = map['createdUser'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
