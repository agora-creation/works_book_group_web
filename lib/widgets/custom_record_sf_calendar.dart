import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_group_web/common/style.dart';

class CustomRecordSfCalendar extends StatelessWidget {
  final CalendarDataSource<Object?>? dataSource;
  final Function(CalendarTapDetails)? onTap;

  const CustomRecordSfCalendar({
    required this.dataSource,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      viewNavigationMode: ViewNavigationMode.none,
      view: CalendarView.month,
      cellBorderColor: kGrey2Color,
      dataSource: dataSource,
      monthViewSettings: const MonthViewSettings(
        showTrailingAndLeadingDates: false,
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      initialDisplayDate: DateTime(2023, 7, 1),
      selectionDecoration: BoxDecoration(
        color: kBaseColor.withOpacity(0.1),
        border: Border.all(color: kBaseColor, width: 2),
        shape: BoxShape.rectangle,
      ),
      headerDateFormat: 'yyyy年MM月',
      headerHeight: 0,
      onTap: onTap,
    );
  }
}
