import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/providers/auth.dart';

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
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '各スタッフが打刻した勤怠データを月毎にで一覧表示します。',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
