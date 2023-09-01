import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/record.dart';
import 'package:works_book_group_web/models/user.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/services/record.dart';
import 'package:works_book_group_web/services/user.dart';
import 'package:works_book_group_web/widgets/custom_icon_text_button.dart';
import 'package:works_book_group_web/widgets/custom_record_shift.dart';

class _ShiftDataSource extends sfc.CalendarDataSource {
  _ShiftDataSource(
      List<sfc.Appointment> source, List<sfc.CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}

class RecordScreen extends StatefulWidget {
  final AuthProvider authProvider;

  const RecordScreen({
    required this.authProvider,
    super.key,
  });

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  RecordService recordService = RecordService();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomIconTextButton(
                    iconData: FluentIcons.download,
                    iconColor: kWhiteColor,
                    labelText: 'CSVダウンロード',
                    labelColor: kWhiteColor,
                    backgroundColor: kGreenColor,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder2<QuerySnapshot<Map<String, dynamic>>,
                    QuerySnapshot<Map<String, dynamic>>>(
                  streams: StreamTuple2(
                    userService.streamList(
                      widget.authProvider.group?.number,
                    ),
                    recordService.streamList(
                      widget.authProvider.group?.number,
                    ),
                  ),
                  builder: (context, snapshot) {
                    List<sfc.CalendarResource> employees = [];
                    if (snapshot.snapshot1.hasData) {
                      for (DocumentSnapshot<Map<String, dynamic>> doc
                          in snapshot.snapshot1.data!.docs) {
                        UserModel user = UserModel.fromSnapshot(doc);
                        employees.add(sfc.CalendarResource(
                          displayName: user.name,
                          id: user.id,
                          color: kBaseColor,
                        ));
                      }
                    }
                    List<sfc.Appointment> shifts = [];
                    if (snapshot.snapshot2.hasData) {
                      for (DocumentSnapshot<Map<String, dynamic>> doc
                          in snapshot.snapshot2.data!.docs) {
                        RecordModel record = RecordModel.fromSnapshot(doc);
                        List<Object> employeeIds = [record.userId];
                        shifts.add(sfc.Appointment(
                          startTime: record.startedAt,
                          endTime: record.endedAt,
                          subject: record.recordTime(),
                          color: kBaseColor,
                          recurrenceId: employeeIds,
                        ));
                      }
                    }
                    return CustomRecordShift(
                      shifts: shifts,
                      employees: employees,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
