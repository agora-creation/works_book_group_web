import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/plan.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/screens/schedule_data_source.dart';
import 'package:works_book_group_web/services/plan.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_sf_calendar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: planService.streamList(
              widget.authProvider.group?.number,
            ),
            builder: (context, snapshot) {
              List<PlanModel> plans = [];
              if (snapshot.hasData) {
                for (DocumentSnapshot<Map<String, dynamic>> doc
                    in snapshot.data!.docs) {
                  plans.add(PlanModel.fromSnapshot(doc));
                }
              }
              return CustomSfCalendar(
                dataSource: ScheduleDataSource(plans),
                onTap: (CalendarTapDetails details) async {
                  dynamic appointment = details.appointments;
                  if (appointment.isNotEmpty) {
                    await showDialog(
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
      ),
    );
  }
}

class ModPlanDialog extends StatefulWidget {
  final PlanModel plan;

  const ModPlanDialog({
    required this.plan,
    super.key,
  });

  @override
  State<ModPlanDialog> createState() => _ModPlanDialogState();
}

class _ModPlanDialogState extends State<ModPlanDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(
        widget.plan.title,
        style: const TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          widget.plan.allDay
              ? Text('予定日: ${dateText('yyyy/MM/dd', widget.plan.startedAt)}')
              : Text(
                  '予定日: ${dateText('yyyy/MM/dd HH:mm', widget.plan.startedAt)}～${dateText('yyyy/MM/dd HH:mm', widget.plan.endedAt)}'),
          Text('作成日時: ${dateText('yyyy/MM/dd HH:mm', widget.plan.createdAt)}'),
          Text('作成者: ${widget.plan.createdUser}'),
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
