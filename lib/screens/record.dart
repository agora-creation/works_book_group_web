import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;
import 'package:universal_html/html.dart';
import 'package:works_book_group_web/common/custom_date_time_picker.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/record.dart';
import 'package:works_book_group_web/models/user.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/services/record.dart';
import 'package:works_book_group_web/services/user.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_date_box.dart';
import 'package:works_book_group_web/widgets/custom_icon_text_button.dart';
import 'package:works_book_group_web/widgets/custom_record_shift.dart';
import 'package:works_book_group_web/widgets/custom_time_box.dart';

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
                    onPressed: () async {
                      final fileName =
                          '${dateText('yyyyMMddHHmmss', DateTime.now())}.csv';
                      List<String> header = [
                        'ユーザーID',
                        '出勤時間',
                        '退勤時間',
                        '休憩時間',
                        '勤務時間',
                      ];
                      List<RecordModel> records =
                          await recordService.selectList(
                        widget.authProvider.group?.number,
                      );
                      List<List<String>> rows = [];
                      for (RecordModel record in records) {
                        List<String> row = [];
                        row.add(record.userId);
                        row.add(dateText('yyyy/MM/dd HH:mm', record.startedAt));
                        row.add(dateText('yyyy/MM/dd HH:mm', record.endedAt));
                        row.add(record.restTimes());
                        row.add(record.recordTime());
                        rows.add(row);
                      }
                      String csv = const ListToCsvConverter().convert(
                        [header, ...rows],
                      );
                      String bom = '\uFEFF';
                      String csvText = bom + csv;
                      csvText = csvText.replaceAll('[', '');
                      csvText = csvText.replaceAll(']', '');
                      AnchorElement(href: 'data:text/plain;charset=utf-8,$csvText')
                        ..setAttribute('download', fileName)
                        ..click();
                    },
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
                            subject: '勤務時間 ${record.recordTime()}',
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
                      onTap: (sfc.CalendarTapDetails details) {
                        dynamic appointment = details.appointments;
                        if (appointment != null) {
                          showDialog(
                            context: context,
                            builder: (context) => ModRecordDialog(
                              record: appointment.first,
                            ),
                          );
                        }
                      },
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

class ModRecordDialog extends StatefulWidget {
  final sfc.Appointment record;

  const ModRecordDialog({
    required this.record,
    super.key,
  });

  @override
  State<ModRecordDialog> createState() => _ModRecordDialogState();
}

class _ModRecordDialogState extends State<ModRecordDialog> {
  RecordService recordService = RecordService();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();

  void _init() {
    setState(() {
      startedAt = widget.record.startTime;
      endedAt = widget.record.endTime;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(
        widget.record.subject,
        style: const TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '出勤時間',
            child: Column(
              children: [
                CustomDateBox(
                  value: startedAt,
                  onTap: () async {
                    final result = await CustomDateTimePicker().showDateChange(
                      context: context,
                      value: startedAt,
                    );
                    setState(() {
                      startedAt = result;
                    });
                  },
                ),
                const SizedBox(height: 8),
                CustomTimeBox(
                  value: startedAt,
                  onTap: () async {
                    final result = await CustomDateTimePicker().showTimeChange(
                      context: context,
                      value: startedAt,
                    );
                    setState(() {
                      startedAt = result;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '退勤時間',
            child: Column(
              children: [
                CustomDateBox(
                  value: endedAt,
                  onTap: () async {
                    final result = await CustomDateTimePicker().showDateChange(
                      context: context,
                      value: endedAt,
                    );
                    setState(() {
                      endedAt = result;
                    });
                  },
                ),
                const SizedBox(height: 8),
                CustomTimeBox(
                  value: endedAt,
                  onTap: () async {
                    final result = await CustomDateTimePicker().showTimeChange(
                      context: context,
                      value: endedAt,
                    );
                    setState(() {
                      endedAt = result;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          labelText: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            recordService.delete({'id': widget.record.id});
            Navigator.pop(context);
          },
        ),
        CustomButton(
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            recordService.update({
              'id': widget.record.id,
              'startedAt': startedAt,
              'endedAt': endedAt,
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
