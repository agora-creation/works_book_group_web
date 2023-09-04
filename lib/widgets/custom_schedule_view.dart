import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/common/style.dart';

class CustomScheduleView extends StatelessWidget {
  final List<Appointment> plans;
  final Function(CalendarTapDetails)? onTap;

  const CustomScheduleView({
    required this.plans,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      showDatePickerButton: true,
      showTodayButton: true,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      view: CalendarView.schedule,
      scheduleViewSettings: const ScheduleViewSettings(
        hideEmptyScheduleWeek: true,
        appointmentTextStyle: TextStyle(
          color: kBlackColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        dayHeaderSettings: DayHeaderSettings(
          dayFormat: 'EEEE',
          dateTextStyle: TextStyle(
            fontSize: 16,
          ),
          dayTextStyle: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      dataSource: _DataSource(plans),
      initialSelectedDate: DateTime.now(),
      headerDateFormat: 'yyyy年MM月',
      onTap: onTap,
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

Widget scheduleViewBuilder(
  BuildContext buildContext,
  ScheduleViewMonthHeaderDetails details,
) {
  return Stack(
    children: <Widget>[
      Image(
        image: ExactAssetImage(
          'assets/images/months/${details.date.month}.png',
        ),
        fit: BoxFit.cover,
        width: details.bounds.width,
        height: details.bounds.height,
      ),
      Positioned(
        left: 55,
        right: 0,
        top: 20,
        bottom: 0,
        child: Text(
          dateText('yyyy年MM月', details.date),
          style: const TextStyle(fontSize: 18),
        ),
      )
    ],
  );
}
