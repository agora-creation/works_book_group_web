import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:works_book_group_web/common/style.dart';

class PlanModel {
  String _id = '';
  String _groupNumber = '';
  String _userId = '';
  String _userName = '';
  String _name = '';
  String _details = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  Color _color = kPlanColors.first;
  bool _allDay = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupNumber => _groupNumber;
  String get userId => _userId;
  String get userName => _userName;
  String get name => _name;
  String get details => _details;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  Color get color => _color;
  bool get allDay => _allDay;
  DateTime get createdAt => _createdAt;

  PlanModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupNumber = map['groupNumber'] ?? '';
    _userId = map['userId'] ?? '';
    _userName = map['userName'] ?? '';
    _name = map['name'] ?? '';
    _details = map['details'] ?? '';
    if (map['startedAt'] != null) {
      _startedAt = map['startedAt'].toDate() ?? DateTime.now();
    }
    if (map['endedAt'] != null) {
      _endedAt = map['endedAt'].toDate() ?? DateTime.now();
    }
    if (map['color'] != null) {
      _color = Color(int.parse(map['color'], radix: 16));
    }
    _allDay = map['allDay'] ?? false;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
