import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/models/record_rest.dart';

class RecordModel {
  String _id = '';
  String _groupNumber = '';
  String _userId = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  List<RecordRestModel> recordRests = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupNumber => _groupNumber;
  String get userId => _userId;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  DateTime get createdAt => _createdAt;

  RecordModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupNumber = map['groupNumber'] ?? '';
    _userId = map['userId'] ?? '';
    if (map['startedAt'] != null) {
      _startedAt = map['startedAt'].toDate() ?? DateTime.now();
    }
    if (map['endedAt'] != null) {
      _endedAt = map['endedAt'].toDate() ?? DateTime.now();
    }
    recordRests = _convertRecordRests(map['recordRests']);
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }

  List<RecordRestModel> _convertRecordRests(List list) {
    List<RecordRestModel> ret = [];
    for (Map map in list) {
      ret.add(RecordRestModel.fromMap(map));
    }
    return ret;
  }

  String startTime() {
    return dateText('HH:mm', _startedAt);
  }

  String endTime() {
    return dateText('HH:mm', _endedAt);
  }

  String restTimes() {
    String ret = '00:00';
    if (recordRests.isNotEmpty) {
      for (RecordRestModel recordRest in recordRests) {
        ret = addTime(ret, recordRest.restTime());
      }
    }
    return ret;
  }

  String recordTime() {
    String ret = '00:00';
    String startedDate = dateText('yyyy-MM-dd', _startedAt);
    String startedTime = '${startTime()}:00.000';
    DateTime startedDateTime = DateTime.parse('$startedDate $startedTime');
    String endedDate = dateText('yyyy-MM-dd', _endedAt);
    String endedTime = '${endTime()}:00.000';
    DateTime endedDateTime = DateTime.parse('$endedDate $endedTime');
    //出勤時間と退勤時間の差を求める
    Duration diff = endedDateTime.difference(startedDateTime);
    String diffMinutes = twoDigits(diff.inMinutes.remainder(60));
    ret = '${twoDigits(diff.inHours)}:$diffMinutes';
    //勤務時間と休憩の合計時間の差を求める
    ret = subTime(ret, restTimes());
    return ret;
  }
}
