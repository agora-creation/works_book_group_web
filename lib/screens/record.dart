import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/record.dart';
import 'package:works_book_group_web/models/user.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/services/record.dart';
import 'package:works_book_group_web/services/user.dart';
import 'package:works_book_group_web/widgets/custom_icon_text_button.dart';
import 'package:works_book_group_web/widgets/custom_record_shift.dart';

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
  List<sfc.CalendarResource> employees = [];
  List<sfc.Appointment> shifts = [];

  void _init() async {
    List<UserModel> users = await userService.selectList(
      widget.authProvider.group?.number,
    );
    if (mounted) {
      setState(() {
        for (UserModel user in users) {
          employees.add(sfc.CalendarResource(
            displayName: user.name,
            id: user.id,
            color: kBaseColor,
          ));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

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
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: recordService.streamList(
                    widget.authProvider.group?.number,
                  ),
                  builder: (context, snapshot) {
                    shifts.clear();
                    if (snapshot.hasData) {
                      for (DocumentSnapshot<Map<String, dynamic>> doc
                          in snapshot.data!.docs) {
                        RecordModel record = RecordModel.fromSnapshot(doc);
                        if (record.startedAt != record.endedAt) {
                          shifts.add(sfc.Appointment(
                            startTime: record.startedAt,
                            endTime: record.endedAt,
                            subject: '${record.recordTime()} 働いた！',
                            color: kGrey2Color,
                            resourceIds: [record.userId],
                            id: record.id,
                          ));
                        }
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
