import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_group_web/common/style.dart';

class CustomSfCalendar extends StatelessWidget {
  final CalendarDataSource<Object?>? dataSource;
  final Function(CalendarTapDetails)? onTap;

  const CustomSfCalendar({
    required this.dataSource,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.week,
      allowedViews: const [
        CalendarView.day,
        CalendarView.week,
        CalendarView.month,
      ],
      dataSource: dataSource,
      selectionDecoration: BoxDecoration(
        color: kBaseColor.withOpacity(0.1),
        border: Border.all(color: kBaseColor, width: 2),
        shape: BoxShape.rectangle,
      ),
      headerDateFormat: 'yyyy年MM月',
      onTap: onTap,
    );
  }
}
