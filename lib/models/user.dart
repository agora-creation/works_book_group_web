import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _id = '';
  String _number = '';
  String _name = '';
  String _email = '';
  String _password = '';
  String _groupNumber = '';
  String _recordId = '';
  String _recordRestId = '';
  String _token = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get number => _number;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get groupNumber => _groupNumber;
  String get recordId => _recordId;
  String get recordRestId => _recordRestId;
  String get token => _token;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _number = map['number'] ?? '';
    _name = map['name'] ?? '';
    _email = map['email'] ?? '';
    _password = map['password'] ?? '';
    _groupNumber = map['groupNumber'] ?? '';
    _recordId = map['recordId'] ?? '';
    _recordRestId = map['recordRestId'] ?? '';
    _token = map['token'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
