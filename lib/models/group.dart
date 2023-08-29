import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String _id = '';
  String _number = '';
  String _name = '';
  String _zipCode = '';
  String _address = '';
  String _tel = '';
  String _email = '';
  String _password = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get number => _number;
  String get name => _name;
  String get zipCode => _zipCode;
  String get address => _address;
  String get tel => _tel;
  String get email => _email;
  String get password => _password;
  DateTime get createdAt => _createdAt;

  GroupModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _number = map['number'] ?? '';
    _name = map['name'] ?? '';
    _zipCode = map['zipCode'] ?? '';
    _address = map['address'] ?? '';
    _tel = map['tel'] ?? '';
    _email = map['email'] ?? '';
    _password = map['password'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
