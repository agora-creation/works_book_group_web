import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/record.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/screens/record_data_source.dart';
import 'package:works_book_group_web/services/record.dart';
import 'package:works_book_group_web/widgets/custom_icon_text_button.dart';
import 'package:works_book_group_web/widgets/custom_record_sf_calendar.dart';

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
                    List<RecordModel> records = [];
                    if (snapshot.hasData) {
                      for (DocumentSnapshot<Map<String, dynamic>> doc
                          in snapshot.data!.docs) {
                        records.add(RecordModel.fromSnapshot(doc));
                      }
                    }
                    return CustomRecordSfCalendar(
                      dataSource: RecordDataSource(records),
                      onTap: (CalendarTapDetails details) async {},
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
