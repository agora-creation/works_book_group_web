import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;
import 'package:universal_html/html.dart';
import 'package:works_book_group_web/common/custom_date_time_picker.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/group.dart';
import 'package:works_book_group_web/models/record.dart';
import 'package:works_book_group_web/models/record_rest.dart';
import 'package:works_book_group_web/models/user.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/services/record.dart';
import 'package:works_book_group_web/services/user.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_date_box.dart';
import 'package:works_book_group_web/widgets/custom_icon_text_button.dart';
import 'package:works_book_group_web/widgets/custom_month_box.dart';
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
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => CsvDialog(
                        group: widget.authProvider.group,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomIconTextButton(
                    iconData: FluentIcons.settings,
                    iconColor: kWhiteColor,
                    labelText: '勤怠設定',
                    labelColor: kWhiteColor,
                    backgroundColor: kGreyColor,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const SettingsDialog(),
                    ),
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
                              appointment: appointment.first,
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

class CsvDialog extends StatefulWidget {
  final GroupModel? group;

  const CsvDialog({
    required this.group,
    super.key,
  });

  @override
  State<CsvDialog> createState() => _CsvDialogState();
}

class _CsvDialogState extends State<CsvDialog> {
  RecordService recordService = RecordService();
  UserService userService = UserService();
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'CSVダウンロード',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CSVファイルをダウンロードします。対象の年月を選択してください。'),
          const SizedBox(height: 8),
          CustomMonthBox(
            value: selectedMonth,
            onTap: () async {
              var selected = await showMonthPicker(
                context: context,
                initialDate: selectedMonth,
              );
              if (selected != null) {
                setState(() {
                  selectedMonth = selected;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: 'ダウンロード',
          labelColor: kWhiteColor,
          backgroundColor: kGreenColor,
          onPressed: () async {
            final fileName =
                '${dateText('yyyyMMddHHmmss', DateTime.now())}.csv';
            List<String> header = [
              'ユーザーID',
              'ユーザー名',
              '合計勤務時間',
              '合計休憩時間',
            ];
            DateTime monthStart =
                DateTime(selectedMonth.year, selectedMonth.month, 1);
            DateTime monthEnd =
                DateTime(selectedMonth.year, selectedMonth.month + 1, 1).add(
              const Duration(days: -1),
            );
            List<UserModel> users = await userService.selectList(
              widget.group?.number,
            );
            List<List<String>> rows = [];
            for (UserModel user in users) {
              List<String> row = [];
              row.add(user.id);
              row.add(user.name);
              row.add('00:00');
              row.add('00:00');
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
    );
  }
}

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '勤怠設定',
        style: TextStyle(fontSize: 18),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('休憩時間の自動設定'),
          Text('時間のまるめ設定'),
          Text('法定労働時間'),
          Text('所定の勤務時間帯'),
          Text('所定の深夜時間帯'),
          Text('休日設定'),
        ],
      ),
      actions: [
        CustomButton(
          labelText: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class ModRecordDialog extends StatefulWidget {
  final sfc.Appointment appointment;

  const ModRecordDialog({
    required this.appointment,
    super.key,
  });

  @override
  State<ModRecordDialog> createState() => _ModRecordDialogState();
}

class _ModRecordDialogState extends State<ModRecordDialog> {
  RecordService recordService = RecordService();
  RecordModel? record;
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  List<RecordRestModel> recordRests = [];

  void _init() async {
    RecordModel? tmpRecord = await recordService.select(
      '${widget.appointment.id}',
    );
    if (tmpRecord != null) {
      setState(() {
        record = tmpRecord;
        startedAt = tmpRecord.startedAt;
        endedAt = tmpRecord.endedAt;
        recordRests = tmpRecord.recordRests;
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
    return ContentDialog(
      title: Text(
        '勤務時間 ${record?.recordTime()}',
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
          const SizedBox(height: 16),
          Column(
            children: recordRests.map((recordRest) {
              return Column(
                children: [
                  InfoLabel(
                    label: '休憩開始時間',
                    child: Column(
                      children: [
                        CustomDateBox(
                          value: recordRest.startedAt,
                          onTap: () async {
                            final result =
                                await CustomDateTimePicker().showDateChange(
                              context: context,
                              value: recordRest.startedAt,
                            );
                            setState(() {
                              recordRest.startedAt = result;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomTimeBox(
                          value: recordRest.startedAt,
                          onTap: () async {
                            final result =
                                await CustomDateTimePicker().showTimeChange(
                              context: context,
                              value: recordRest.startedAt,
                            );
                            setState(() {
                              recordRest.startedAt = result;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  InfoLabel(
                    label: '休憩終了時間',
                    child: Column(
                      children: [
                        CustomDateBox(
                          value: recordRest.endedAt,
                          onTap: () async {
                            final result =
                                await CustomDateTimePicker().showDateChange(
                              context: context,
                              value: recordRest.endedAt,
                            );
                            setState(() {
                              recordRest.endedAt = result;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomTimeBox(
                          value: recordRest.endedAt,
                          onTap: () async {
                            final result =
                                await CustomDateTimePicker().showTimeChange(
                              context: context,
                              value: recordRest.endedAt,
                            );
                            setState(() {
                              recordRest.endedAt = result;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }).toList(),
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
            recordService.delete({'id': record?.id});
            Navigator.pop(context);
          },
        ),
        CustomButton(
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            List<Map> recordRestsMap = [];
            for (RecordRestModel recordRest in recordRests) {
              recordRestsMap.add(recordRest.toMap());
            }
            recordService.update({
              'id': record?.id,
              'startedAt': startedAt,
              'endedAt': endedAt,
              'recordRests': recordRestsMap,
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
