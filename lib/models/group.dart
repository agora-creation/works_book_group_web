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
  int _legalHour = 8;
  int _roundStartedAtType = 0;
  int _roundStartedAtMinute = 1;
  int _roundEndedAtType = 0;
  int _roundEndedAtMinute = 1;
  int _roundRestStartedAtType = 0;
  int _roundRestStartedAtMinute = 1;
  int _roundRestEndedAtType = 0;
  int _roundRestEndedAtMinute = 1;
  int _roundDiffType = 0;
  int _roundDiffMinute = 1;
  String _fixedStartedAt = '09:00';
  String _fixedEndedAt = '17:00';
  String _nightStartedAt = '22:00';
  String _nightEndedAt = '05:00';
  List<String> holidayWeeks = [];
  List<DateTime> holidays = [];
  bool _autoRest = false;

  String get id => _id;
  String get number => _number;
  String get name => _name;
  String get zipCode => _zipCode;
  String get address => _address;
  String get tel => _tel;
  String get email => _email;
  String get password => _password;
  DateTime get createdAt => _createdAt;
  int get legalHour => _legalHour;
  int get roundStartedAtType => _roundStartedAtType;
  int get roundStartedAtMinute => _roundStartedAtMinute;
  int get roundEndedAtType => _roundEndedAtType;
  int get roundEndedAtMinute => _roundEndedAtMinute;
  int get roundRestStartedAtType => _roundRestStartedAtType;
  int get roundRestStartedAtMinute => _roundRestStartedAtMinute;
  int get roundRestEndedAtType => _roundRestEndedAtType;
  int get roundRestEndedAtMinute => _roundRestEndedAtMinute;
  int get roundDiffType => _roundDiffType;
  int get roundDiffMinute => _roundDiffMinute;
  String get fixedStartedAt => _fixedStartedAt;
  String get fixedEndedAt => _fixedEndedAt;
  String get nightStartedAt => _nightStartedAt;
  String get nightEndedAt => _nightEndedAt;
  bool get autoRest => _autoRest;

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
    _legalHour = map['legalHour'] ?? 8;
    _roundStartedAtType = map['roundStartedAtType'] ?? 0;
    _roundStartedAtMinute = map['roundStartedAtMinute'] ?? 1;
    _roundEndedAtType = map['roundEndedAtType'] ?? 0;
    _roundEndedAtMinute = map['roundEndedAtMinute'] ?? 1;
    _roundRestStartedAtType = map['roundRestStartedAtType'] ?? 0;
    _roundRestStartedAtMinute = map['roundRestStartedAtMinute'] ?? 1;
    _roundRestEndedAtType = map['roundRestEndedAtType'] ?? 0;
    _roundRestEndedAtMinute = map['roundRestEndedAtMinute'] ?? 1;
    _roundDiffType = map['roundDiffType'] ?? 0;
    _roundDiffMinute = map['roundDiffMinute'] ?? 1;
    _fixedStartedAt = map['fixedStartedAt'] ?? '09:00';
    _fixedEndedAt = map['fixedEndedAt'] ?? '17:00';
    _nightStartedAt = map['nightStartedAt'] ?? '22:00';
    _nightEndedAt = map['nightEndedAt'] ?? '05:00';
    holidayWeeks = _convertHolidayWeeks(map['holidayWeeks'] ?? []);
    holidays = _convertHolidays(map['holidays'] ?? []);
    _autoRest = map['autoRest'] ?? false;
  }

  List<String> _convertHolidayWeeks(List list) {
    List<String> converted = [];
    for (String data in list) {
      converted.add(data);
    }
    return converted;
  }

  List<DateTime> _convertHolidays(List list) {
    List<DateTime> converted = [];
    for (var value in list) {
      DateTime dateTime = value.toDate();
      converted.add(dateTime);
    }
    return converted;
  }
}
