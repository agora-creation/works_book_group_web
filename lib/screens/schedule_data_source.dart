import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_group_web/models/plan.dart';

class ScheduleDataSource extends CalendarDataSource {
  ScheduleDataSource(List<PlanModel> source) {
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
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].allDay;
  }
}
