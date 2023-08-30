import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/record.dart';

class RecordDataSource extends CalendarDataSource {
  RecordDataSource(List<RecordModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startedAt;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endedAt;
  }

  @override
  String getSubject(int index) {
    return appointments![index].recordTime();
  }

  @override
  Color getColor(int index) {
    return kGreyColor;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
