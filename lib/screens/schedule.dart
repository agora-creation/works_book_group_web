import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_group_web/common/custom_date_time_picker.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/group.dart';
import 'package:works_book_group_web/models/plan.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/services/plan.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_date_box.dart';
import 'package:works_book_group_web/widgets/custom_icon_text_button.dart';
import 'package:works_book_group_web/widgets/custom_schedule_view.dart';
import 'package:works_book_group_web/widgets/custom_text_box.dart';
import 'package:works_book_group_web/widgets/custom_time_box.dart';

class ScheduleScreen extends StatefulWidget {
  final AuthProvider authProvider;

  const ScheduleScreen({
    required this.authProvider,
    super.key,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  PlanService planService = PlanService();
  List<Appointment> plans = [];

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
                    iconData: FluentIcons.add,
                    iconColor: kWhiteColor,
                    labelText: '予定を追加',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AddPlanDialog(
                        group: widget.authProvider.group,
                        dateTime: DateTime.now(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: planService.streamList(
                    widget.authProvider.group?.number,
                  ),
                  builder: (context, snapshot) {
                    plans.clear();
                    if (snapshot.hasData) {
                      for (DocumentSnapshot<Map<String, dynamic>> doc
                          in snapshot.data!.docs) {
                        PlanModel plan = PlanModel.fromSnapshot(doc);
                        plans.add(Appointment(
                          startTime: plan.startedAt,
                          endTime: plan.endedAt,
                          subject: plan.title,
                          notes: plan.details,
                          color: plan.color,
                          isAllDay: plan.allDay,
                          id: plan.id,
                        ));
                      }
                    }
                    return CustomScheduleView(
                      plans: plans,
                      onTap: (CalendarTapDetails details) async {
                        dynamic appointment = details.appointments;
                        if (appointment != null) {
                          showDialog(
                            context: context,
                            builder: (context) => ModPlanDialog(
                              plan: appointment.first,
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

class AddPlanDialog extends StatefulWidget {
  final GroupModel? group;
  final DateTime dateTime;

  const AddPlanDialog({
    required this.group,
    required this.dateTime,
    super.key,
  });

  @override
  State<AddPlanDialog> createState() => _AddPlanDialogState();
}

class _AddPlanDialogState extends State<AddPlanDialog> {
  PlanService planService = PlanService();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  String color = kPlanColors.first.value.toRadixString(16);
  bool allDay = false;

  void _init() {
    setState(() {
      startedAt = widget.dateTime;
      endedAt = startedAt.add(const Duration(hours: 1));
    });
  }

  void _allDayChange(bool value) {
    setState(() {
      allDay = value;
      if (value) {
        startedAt = DateTime(
          startedAt.year,
          startedAt.month,
          startedAt.day,
          0,
          0,
          0,
        );
        endedAt = DateTime(
          endedAt.year,
          endedAt.month,
          endedAt.day,
          23,
          59,
          59,
        );
      }
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
      title: const Text(
        '予定を追加',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: 'タイトル',
            child: CustomTextBox(
              controller: titleController,
              placeholder: '',
              keyboardType: TextInputType.name,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '詳細',
            child: CustomTextBox(
              controller: detailsController,
              placeholder: '',
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          const SizedBox(height: 8),
          ToggleSwitch(
            checked: allDay,
            content: const Text('終日'),
            onChanged: _allDayChange,
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '開始日時',
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
            label: '終了日時',
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
          const SizedBox(height: 8),
          InfoLabel(
            label: '色',
            child: ComboBox(
              value: color,
              items: kPlanColors.map((Color value) {
                return ComboBoxItem(
                  value: value.value.toRadixString(16),
                  child: Container(
                    color: value,
                    width: 50,
                    height: 25,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  color = value!;
                });
              },
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
          labelText: '上記内容で追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            if (titleController.text == '') return;
            String id = planService.id();
            planService.create({
              'id': id,
              'groupNumber': widget.group?.number,
              'title': titleController.text,
              'details': detailsController.text,
              'startedAt': startedAt,
              'endedAt': endedAt,
              'color': color,
              'allDay': allDay,
              'createdUser': '管理者',
              'createdAt': DateTime.now(),
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModPlanDialog extends StatefulWidget {
  final Appointment plan;

  const ModPlanDialog({
    required this.plan,
    super.key,
  });

  @override
  State<ModPlanDialog> createState() => _ModPlanDialogState();
}

class _ModPlanDialogState extends State<ModPlanDialog> {
  PlanService planService = PlanService();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  String color = kPlanColors.first.value.toRadixString(16);
  bool allDay = false;

  void _init() {
    setState(() {
      titleController.text = widget.plan.subject;
      detailsController.text = widget.plan.notes ?? '';
      startedAt = widget.plan.startTime;
      endedAt = widget.plan.endTime;
      color = widget.plan.color.value.toRadixString(16);
      allDay = widget.plan.isAllDay;
    });
  }

  void _allDayChange(bool value) {
    setState(() {
      allDay = value;
      if (value) {
        startedAt = DateTime(
          startedAt.year,
          startedAt.month,
          startedAt.day,
          0,
          0,
          0,
        );
        endedAt = DateTime(
          endedAt.year,
          endedAt.month,
          endedAt.day,
          23,
          59,
          59,
        );
      }
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
      title: const Text(
        '予定を編集',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: 'タイトル',
            child: CustomTextBox(
              controller: titleController,
              placeholder: '',
              keyboardType: TextInputType.name,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '詳細',
            child: CustomTextBox(
              controller: detailsController,
              placeholder: '',
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          const SizedBox(height: 8),
          ToggleSwitch(
            checked: allDay,
            content: const Text('終日'),
            onChanged: _allDayChange,
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '開始日時',
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
            label: '終了日時',
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
          const SizedBox(height: 8),
          InfoLabel(
            label: '色',
            child: ComboBox(
              value: color,
              items: kPlanColors.map((Color value) {
                return ComboBoxItem(
                  value: value.value.toRadixString(16),
                  child: Container(
                    color: value,
                    width: 50,
                    height: 25,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  color = value!;
                });
              },
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
            planService.delete({'id': widget.plan.id});
            Navigator.pop(context);
          },
        ),
        CustomButton(
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            if (titleController.text == '') return;
            planService.update({
              'id': widget.plan.id,
              'title': titleController.text,
              'details': detailsController.text,
              'startedAt': startedAt,
              'endedAt': endedAt,
              'color': color,
              'allDay': allDay,
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
