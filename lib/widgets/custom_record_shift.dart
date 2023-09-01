import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class CustomRecordShift extends StatelessWidget {
  final List<sfc.Appointment> shifts;
  final List<sfc.CalendarResource> employees;

  const CustomRecordShift({
    required this.shifts,
    required this.employees,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return sfc.SfCalendar(
      showDatePickerButton: true,
      view: sfc.CalendarView.timelineMonth,
      showNavigationArrow: true,
      dataSource: _ShiftDataSource(shifts, employees),
      headerDateFormat: 'yyyy年MM月',
    );
  }
}

class _ShiftDataSource extends sfc.CalendarDataSource {
  _ShiftDataSource(
      List<sfc.Appointment> source, List<sfc.CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}
