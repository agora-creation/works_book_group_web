import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/widgets/custom_icon_text_button.dart';

class RecordSettingsScreen extends StatefulWidget {
  final AuthProvider authProvider;

  const RecordSettingsScreen({
    required this.authProvider,
    super.key,
  });

  @override
  State<RecordSettingsScreen> createState() => _RecordSettingsScreenState();
}

class _RecordSettingsScreenState extends State<RecordSettingsScreen> {
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
                    iconData: FluentIcons.save,
                    iconColor: kWhiteColor,
                    labelText: '変更内容を保存',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
