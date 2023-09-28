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
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: kGreyColor)),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Row(
                        children: [
                          Icon(FluentIcons.calculator),
                          SizedBox(width: 8),
                          Text(
                            '帳票出力時の時間の計算に使う設定',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoLabel(
                      label: '法定労働時間',
                      child: ComboBox<String>(
                        value: '8時間',
                        items: const [
                          ComboBoxItem(
                            value: '8時間',
                            child: Text('8時間'),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoLabel(
                      label: '出勤時間の丸め方',
                      child: ComboBox<String>(
                        value: '切捨',
                        items: const [
                          ComboBoxItem(
                            value: '切捨',
                            child: Text('切捨'),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoLabel(
                      label: '出勤時間のまるめ分数',
                      child: ComboBox<String>(
                        value: '1分',
                        items: const [
                          ComboBoxItem(
                            value: '1分',
                            child: Text('1分'),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoLabel(
                      label: '退勤時間の丸め方',
                      child: ComboBox<String>(
                        value: '切捨',
                        items: const [
                          ComboBoxItem(
                            value: '切捨',
                            child: Text('切捨'),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Expander(
                      header: Text('法定労働時間'),
                      content: Column(
                        children: [],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Expander(
                      header: Text('時間のまるめ'),
                      content: Column(
                        children: [],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Expander(
                      header: Text('所定労働時間帯'),
                      content: Column(
                        children: [],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Expander(
                      header: Text('深夜時間帯'),
                      content: Column(
                        children: [],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Expander(
                      header: Text('休日指定(曜日)'),
                      content: Column(
                        children: [],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Expander(
                      header: Text('休日指定(日付)'),
                      content: Column(
                        children: [],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: kGreyColor)),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Row(
                        children: [
                          Icon(FluentIcons.calculator),
                          SizedBox(width: 8),
                          Text(
                            '打刻時の設定',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Expander(
                      header: Text('休憩時間の自動付与'),
                      content: Column(
                        children: [],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
