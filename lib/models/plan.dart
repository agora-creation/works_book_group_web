import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:works_book_group_web/common/style.dart';

class PlanModel {
  String _id = '';
  String _groupNumber = '';
  String _title = '';
  String _details = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  Color _color = kPlanColors.first;
  bool _allDay = false;
  String _createdUser = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupNumber => _groupNumber;
  String get title => _title;
  String get details => _details;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  Color get color => _color;
  bool get allDay => _allDay;
  String get createdUser => _createdUser;
  DateTime get createdAt => _createdAt;

  PlanModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupNumber = map['groupNumber'] ?? '';
    _title = map['title'] ?? '';
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
    _createdUser = map['createdUser'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
