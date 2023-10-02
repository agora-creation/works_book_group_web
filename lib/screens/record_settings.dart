import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:works_book_group_web/common/custom_date_time_picker.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/group.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_icon_header.dart';
import 'package:works_book_group_web/widgets/custom_setting_list.dart';
import 'package:works_book_group_web/widgets/custom_time_box.dart';

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
    String holidayWeeksText = '';
    for (String week in group?.holidayWeeks ?? []) {
      if (holidayWeeksText != '') holidayWeeksText += '／';
      holidayWeeksText += week;
    }
    String holidaysText = '';
    for (DateTime day in group?.holidays ?? []) {
      if (holidaysText != '') holidaysText += '／';
      holidaysText += dateText('yyyy-MM-dd', day);
    }
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
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => RoundRestStartedAtDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
                ),
                CustomSettingList(
                  label: '休憩終了時間の丸め',
                  value:
                      '端数処理[${kRoundTypes[group?.roundRestEndedAtType ?? 0]}]／分数[${group?.roundRestEndedAtMinute ?? 1}分]',
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => RoundRestEndedAtDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
                ),
                CustomSettingList(
                  label: '勤務時間の丸め',
                  value:
                      '端数処理[${kRoundTypes[group?.roundDiffType ?? 0]}]／分数[${group?.roundDiffMinute ?? 1}分]',
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => RoundDiffDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
                ),
                CustomSettingList(
                  label: '所定労働時間帯',
                  value: '${group?.fixedStartedAt}～${group?.fixedEndedAt}',
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => FixedDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
                ),
                CustomSettingList(
                  label: '深夜時間帯',
                  value: '${group?.nightStartedAt}～${group?.nightEndedAt}',
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => NightDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
                ),
                CustomSettingList(
                  label: '休日指定(曜日)',
                  value: holidayWeeksText,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => HolidayWeeksDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
                ),
                CustomSettingList(
                  label: '休日指定(日付)',
                  value: holidaysText,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => HolidaysDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const CustomIconHeader(
                  iconData: FluentIcons.calculator,
                  label: '出退勤打刻時の設定',
                ),
                CustomSettingList(
                  label: '休憩時間の自動打刻(1時間分)',
                  value: group?.autoRest ?? false ? '有効' : '無効',
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AutoRestDialog(
                      authProvider: widget.authProvider,
                    ),
                  ),
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

class RoundRestStartedAtDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const RoundRestStartedAtDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<RoundRestStartedAtDialog> createState() =>
      _RoundRestStartedAtDialogState();
}

class _RoundRestStartedAtDialogState extends State<RoundRestStartedAtDialog> {
  int roundRestStartedAtType = 0;
  int roundRestStartedAtMinute = 1;

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      roundRestStartedAtType = group?.roundRestStartedAtType ?? 0;
      roundRestStartedAtMinute = group?.roundRestStartedAtMinute ?? 1;
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
        '休憩開始時間の丸め',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '端数処理',
            child: ComboBox(
              value: kRoundTypes[roundRestStartedAtType],
              items: kRoundTypes.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  roundRestStartedAtType = kRoundTypes.indexOf('$value');
                });
              },
              isExpanded: true,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '分数',
            child: ComboBox(
              value: roundRestStartedAtMinute,
              items: kRoundMinutes.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text('$e分'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  roundRestStartedAtMinute = value ?? 1;
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
            await widget.authProvider.updateRoundRestStartedAt(
              roundRestStartedAtType: roundRestStartedAtType,
              roundRestStartedAtMinute: roundRestStartedAtMinute,
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

class RoundRestEndedAtDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const RoundRestEndedAtDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<RoundRestEndedAtDialog> createState() => _RoundRestEndedAtDialogState();
}

class _RoundRestEndedAtDialogState extends State<RoundRestEndedAtDialog> {
  int roundRestEndedAtType = 0;
  int roundRestEndedAtMinute = 1;

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      roundRestEndedAtType = group?.roundRestEndedAtType ?? 0;
      roundRestEndedAtMinute = group?.roundRestEndedAtMinute ?? 1;
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
        '休憩終了時間の丸め',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '端数処理',
            child: ComboBox(
              value: kRoundTypes[roundRestEndedAtType],
              items: kRoundTypes.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  roundRestEndedAtType = kRoundTypes.indexOf('$value');
                });
              },
              isExpanded: true,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '分数',
            child: ComboBox(
              value: roundRestEndedAtMinute,
              items: kRoundMinutes.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text('$e分'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  roundRestEndedAtMinute = value ?? 1;
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
            await widget.authProvider.updateRoundRestEndedAt(
              roundRestEndedAtType: roundRestEndedAtType,
              roundRestEndedAtMinute: roundRestEndedAtMinute,
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

class RoundDiffDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const RoundDiffDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<RoundDiffDialog> createState() => _RoundDiffDialogState();
}

class _RoundDiffDialogState extends State<RoundDiffDialog> {
  int roundDiffType = 0;
  int roundDiffMinute = 1;

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      roundDiffType = group?.roundDiffType ?? 0;
      roundDiffMinute = group?.roundDiffMinute ?? 1;
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
        '勤務時間の丸め',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '端数処理',
            child: ComboBox(
              value: kRoundTypes[roundDiffType],
              items: kRoundTypes.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  roundDiffType = kRoundTypes.indexOf('$value');
                });
              },
              isExpanded: true,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '分数',
            child: ComboBox(
              value: roundDiffMinute,
              items: kRoundMinutes.map((e) {
                return ComboBoxItem(
                  value: e,
                  child: Text('$e分'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  roundDiffMinute = value ?? 1;
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
            await widget.authProvider.updateRoundDiff(
              roundDiffType: roundDiffType,
              roundDiffMinute: roundDiffMinute,
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

class FixedDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const FixedDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<FixedDialog> createState() => _FixedDialogState();
}

class _FixedDialogState extends State<FixedDialog> {
  DateTime now = DateTime.now();
  String fixedStartedAt = '09:00';
  String fixedEndedAt = '17:00';

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      fixedStartedAt = group?.fixedStartedAt ?? '09:00';
      fixedEndedAt = group?.fixedEndedAt ?? '17:00';
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startValue = DateTime.parse(
      '${dateText('yyyy-MM-dd', now)} $fixedStartedAt:00.0000',
    );
    DateTime endValue = DateTime.parse(
      '${dateText('yyyy-MM-dd', now)} $fixedEndedAt:00.0000',
    );
    return ContentDialog(
      title: const Text(
        '所定労働時間帯',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '労働開始時間',
            child: CustomTimeBox(
              value: startValue,
              onTap: () async {
                final result = await CustomDateTimePicker().showTimeChange(
                  context: context,
                  value: startValue,
                );
                setState(() {
                  fixedStartedAt = dateText('HH:mm', result);
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '労働終了時間',
            child: CustomTimeBox(
              value: endValue,
              onTap: () async {
                final result = await CustomDateTimePicker().showTimeChange(
                  context: context,
                  value: endValue,
                );
                setState(() {
                  fixedEndedAt = dateText('HH:mm', result);
                });
              },
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
            await widget.authProvider.updateFixed(
              fixedStartedAt: fixedStartedAt,
              fixedEndedAt: fixedEndedAt,
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

class NightDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const NightDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<NightDialog> createState() => _NightDialogState();
}

class _NightDialogState extends State<NightDialog> {
  DateTime now = DateTime.now();
  String nightStartedAt = '22:00';
  String nightEndedAt = '05:00';

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      nightStartedAt = group?.nightStartedAt ?? '22:00';
      nightEndedAt = group?.nightEndedAt ?? '05:00';
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startValue = DateTime.parse(
      '${dateText('yyyy-MM-dd', now)} $nightStartedAt:00.0000',
    );
    DateTime endValue = DateTime.parse(
      '${dateText('yyyy-MM-dd', now)} $nightEndedAt:00.0000',
    );
    return ContentDialog(
      title: const Text(
        '深夜時間帯',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '深夜開始時間',
            child: CustomTimeBox(
              value: startValue,
              onTap: () async {
                final result = await CustomDateTimePicker().showTimeChange(
                  context: context,
                  value: startValue,
                );
                setState(() {
                  nightStartedAt = dateText('HH:mm', result);
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '深夜終了時間',
            child: CustomTimeBox(
              value: endValue,
              onTap: () async {
                final result = await CustomDateTimePicker().showTimeChange(
                  context: context,
                  value: endValue,
                );
                setState(() {
                  nightEndedAt = dateText('HH:mm', result);
                });
              },
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
            await widget.authProvider.updateNight(
              nightStartedAt: nightStartedAt,
              nightEndedAt: nightEndedAt,
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

class HolidayWeeksDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const HolidayWeeksDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<HolidayWeeksDialog> createState() => _HolidayWeeksDialogState();
}

class _HolidayWeeksDialogState extends State<HolidayWeeksDialog> {
  List<String> holidayWeeks = [];

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      holidayWeeks = group?.holidayWeeks ?? [];
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
        '休日指定(曜日)',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: kWeeks.length,
            itemBuilder: (context, index) {
              var contain = holidayWeeks.where((e) => e == kWeeks[index]);
              return Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGreyColor)),
                ),
                child: Checkbox(
                  checked: contain.isNotEmpty,
                  onChanged: (value) {
                    setState(() {
                      if (contain.isEmpty) {
                        holidayWeeks.add(kWeeks[index]);
                      } else {
                        holidayWeeks.remove(kWeeks[index]);
                      }
                    });
                  },
                  content: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(kWeeks[index]),
                  ),
                ),
              );
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
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            await widget.authProvider.updateHolidayWeeks(
              holidayWeeks: holidayWeeks,
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

class HolidaysDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const HolidaysDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<HolidaysDialog> createState() => _HolidaysDialogState();
}

class _HolidaysDialogState extends State<HolidaysDialog> {
  List<DateTime> holidays = [];

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      holidays = group?.holidays ?? [];
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
        '休日指定(日付)',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SfDateRangePicker(
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.multiple,
            initialSelectedDates: holidays,
            onSelectionChanged: (value) {
              List<DateTime> selected = [];
              for (DateTime day in value.value) {
                selected.add(day);
              }
              setState(() {
                holidays = selected;
              });
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
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            await widget.authProvider.updateHolidays(
              holidays: holidays,
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

class AutoRestDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const AutoRestDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<AutoRestDialog> createState() => _AutoRestDialogState();
}

class _AutoRestDialogState extends State<AutoRestDialog> {
  bool autoRest = false;

  void _init() {
    GroupModel? group = widget.authProvider.group;
    setState(() {
      autoRest = group?.autoRest ?? false;
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
        '休憩時間の自動打刻(1時間)',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComboBox(
            value: autoRest,
            items: const [
              ComboBoxItem(
                value: false,
                child: Text('無効'),
              ),
              ComboBoxItem(
                value: true,
                child: Text('有効'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                autoRest = value ?? false;
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
            await widget.authProvider.updateAutoRest(
              autoRest: autoRest,
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
