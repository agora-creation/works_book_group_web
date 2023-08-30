import 'package:works_book_group_web/common/functions.dart';

class RecordRestModel {
  String _id = '';
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();

  String get id => _id;

  RecordRestModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    startedAt = data['startedAt'].toDate() ?? DateTime.now();
    endedAt = data['endedAt'].toDate() ?? DateTime.now();
  }

  Map toMap() => {
        'id': id,
        'startedAt': startedAt,
        'endedAt': endedAt,
      };

  String startTime() {
    return dateText('HH:mm', startedAt);
  }

  String endTime() {
    return dateText('HH:mm', endedAt);
  }

  String restTime() {
    String startedDate = dateText('yyyy-MM-dd', startedAt);
    String startedTime = '${startTime()}:00.000';
    DateTime startedDateTime = DateTime.parse('$startedDate $startedTime');
    String endedDate = dateText('yyyy-MM-dd', endedAt);
    String endedTime = '${endTime()}:00.000';
    DateTime endedDateTime = DateTime.parse('$endedDate $endedTime');
    //休憩開始時間と休憩終了時間の差を求める
    Duration diff = endedDateTime.difference(startedDateTime);
    String diffMinutes = twoDigits(diff.inMinutes.remainder(60));
    return '${twoDigits(diff.inHours)}:$diffMinutes';
  }
}
