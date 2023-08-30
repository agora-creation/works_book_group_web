import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_group_web/models/plan.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/screens/schedule_data_source.dart';
import 'package:works_book_group_web/services/plan.dart';
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 750,
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
                    onTap: (CalendarTapDetails details) async {},
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
