import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/group.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_icon_header.dart';
import 'package:works_book_group_web/widgets/custom_setting_list.dart';

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
    GroupModel? group = widget.authProvider.group;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomIconHeader(
                  iconData: FluentIcons.calculator,
                  label: '帳票出力時の計算に使う設定',
                ),
                CustomSettingList(
                  label: '法定労働時間',
                  value: '${group?.legalHour}時間',
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => LegalHourDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
                ),
                CustomSettingList(
                  label: '出勤時間の丸め',
                  value:
                      '端数処理[${kRoundTypes[group?.roundStartedAtType ?? 0]}]／分数[${group?.roundStartedAtMinute ?? 1}分]',
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => RoundStartedAtDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
                ),
                CustomSettingList(
                  label: '退勤時間の丸め',
                  value:
                      '端数処理[${kRoundTypes[group?.roundEndedAtType ?? 0]}]／分数[${group?.roundEndedAtMinute ?? 1}分]',
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => RoundEndedAtDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
                ),
                CustomSettingList(
                  label: '休憩開始時間の丸め',
                  value:
                      '端数処理[${kRoundTypes[group?.roundRestStartedAtType ?? 0]}]／分数[${group?.roundRestStartedAtMinute ?? 1}分]',
                  onTap: () {},
                ),
                CustomSettingList(
                  label: '休憩終了時間の丸め',
                  value:
                      '端数処理[${kRoundTypes[group?.roundRestEndedAtType ?? 0]}]／分数[${group?.roundRestEndedAtMinute ?? 1}分]',
                  onTap: () {},
                ),
                CustomSettingList(
                  label: '勤務時間の丸め',
                  value:
                      '端数処理[${kRoundTypes[group?.roundDiffType ?? 0]}]／分数[${group?.roundDiffMinute ?? 1}分]',
                  onTap: () {},
                ),
                CustomSettingList(
                  label: '所定労働時間帯',
                  value: '${group?.fixedStartedAt}～${group?.fixedEndedAt}',
                  onTap: () {},
                ),
                CustomSettingList(
                  label: '深夜時間帯',
                  value: '${group?.nightStartedAt}～${group?.nightEndedAt}',
                  onTap: () {},
                ),
                CustomSettingList(
                  label: '休日指定(曜日)',
                  value: '土、日',
                  onTap: () {},
                ),
                CustomSettingList(
                  label: '休日指定(日付)',
                  value: '2021-05-18、2021-12-07',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                const CustomIconHeader(
                  iconData: FluentIcons.calculator,
                  label: '出退勤打刻時の設定',
                ),
                CustomSettingList(
                  label: '休憩時間の自動打刻(1時間分)',
                  value: group?.autoRest ?? false ? '有効' : '無効',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LegalHourDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const LegalHourDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<LegalHourDialog> createState() => _LegalHourDialogState();
}

class _LegalHourDialogState extends State<LegalHourDialog> {
  int legalHour = 8;

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      legalHour = group?.legalHour ?? 8;
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
        '法定労働時間',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComboBox(
            value: legalHour,
            items: kLegalHours.map((e) {
              return ComboBoxItem(
                value: e,
                child: Text('$e時間'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                legalHour = value ?? 8;
              });
            },
            isExpanded: true,
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
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            await widget.authProvider.updateLegalHour(legalHour: legalHour);
            await widget.authProvider.reloadGroup();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class RoundStartedAtDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const RoundStartedAtDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<RoundStartedAtDialog> createState() => _RoundStartedAtDialogState();
}

class _RoundStartedAtDialogState extends State<RoundStartedAtDialog> {
  int roundStartedAtType = 0;
  int roundStartedAtMinute = 1;

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      roundStartedAtType = group?.roundStartedAtType ?? 0;
      roundStartedAtMinute = group?.roundStartedAtMinute ?? 1;
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
        '出勤時間の丸め',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '端数処理',
            child: ComboBox(
              value: kRoundTypes[roundStartedAtType],
              items: kRoundTypes.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  roundStartedAtType = kRoundTypes.indexOf('$value');
                });
              },
              isExpanded: true,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '分数',
            child: ComboBox(
              value: roundStartedAtMinute,
              items: kRoundMinutes.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text('$e分'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  roundStartedAtMinute = value ?? 1;
                });
              },
              isExpanded: true,
            ),
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
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            await widget.authProvider.updateRoundStartedAt(
              roundStartedAtType: roundStartedAtType,
              roundStartedAtMinute: roundStartedAtMinute,
            );
            await widget.authProvider.reloadGroup();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class RoundEndedAtDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const RoundEndedAtDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<RoundEndedAtDialog> createState() => _RoundEndedAtDialogState();
}

class _RoundEndedAtDialogState extends State<RoundEndedAtDialog> {
  int roundEndedAtType = 0;
  int roundEndedAtMinute = 1;

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      roundEndedAtType = group?.roundEndedAtType ?? 0;
      roundEndedAtMinute = group?.roundEndedAtMinute ?? 1;
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
        '退勤時間の丸め',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '端数処理',
            child: ComboBox(
              value: kRoundTypes[roundEndedAtType],
              items: kRoundTypes.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  roundEndedAtType = kRoundTypes.indexOf('$value');
                });
              },
              isExpanded: true,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '分数',
            child: ComboBox(
              value: roundEndedAtMinute,
              items: kRoundMinutes.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text('$e分'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  roundEndedAtMinute = value ?? 1;
                });
              },
              isExpanded: true,
            ),
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
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            await widget.authProvider.updateRoundEndedAt(
              roundEndedAtType: roundEndedAtType,
              roundEndedAtMinute: roundEndedAtMinute,
            );
            await widget.authProvider.reloadGroup();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
