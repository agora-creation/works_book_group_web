import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/group_login.dart';
import 'package:works_book_group_web/services/group_login.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_cell.dart';

class GroupLoginSource extends DataGridSource {
  final BuildContext context;
  final List<GroupLoginModel> groupLogins;

  GroupLoginSource({
    required this.context,
    required this.groupLogins,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = groupLogins.map<DataGridRow>((groupLogin) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: groupLogin.id,
        ),
        DataGridCell(
          columnName: 'createdAt',
          value: dateText('yyyy/MM/dd HH:mm', groupLogin.createdAt),
        ),
        DataGridCell(
          columnName: 'userName',
          value: groupLogin.userName,
        ),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    if ((rowIndex % 2) == 0) {
      backgroundColor = kWhiteColor;
    }
    List<Widget> cells = [];
    GroupLoginModel groupLogin = groupLogins.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    cells.add(CustomCell(label: '${row.getCells()[1].value}'));
    cells.add(CustomCell(label: '${row.getCells()[2].value}'));
    cells.add(Row(
      children: [
        CustomButton(
          labelText: '承認',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => GroupLoginDetailsDialog(
              groupLogin: groupLogin,
              accept: true,
            ),
          ),
        ),
        const SizedBox(width: 4),
        CustomButton(
          labelText: '却下',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => GroupLoginDetailsDialog(
              groupLogin: groupLogin,
              accept: false,
            ),
          ),
        ),
      ],
    ));
    return DataGridRowAdapter(color: backgroundColor, cells: cells);
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    Widget? widget;
    Widget buildCell(
      String value,
      EdgeInsets padding,
      Alignment alignment,
    ) {
      return Container(
        padding: padding,
        alignment: alignment,
        child: Text(value, softWrap: false),
      );
    }

    widget = buildCell(
      summaryValue,
      const EdgeInsets.all(4),
      Alignment.centerLeft,
    );
    return widget;
  }

  void updateDataSource() {
    notifyListeners();
  }
}

class GroupLoginDetailsDialog extends StatefulWidget {
  final GroupLoginModel groupLogin;
  final bool accept;

  const GroupLoginDetailsDialog({
    required this.groupLogin,
    required this.accept,
    super.key,
  });

  @override
  State<GroupLoginDetailsDialog> createState() =>
      _GroupLoginDetailsDialogState();
}

class _GroupLoginDetailsDialogState extends State<GroupLoginDetailsDialog> {
  GroupLoginService groupLoginService = GroupLoginService();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(
        widget.accept ? '所属申請 - 承認' : '所属申請 - 承認',
        style: const TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.accept
              ? const Text('以下の所属申請を承認しますか？')
              : const Text('以下の所属申請を却下しますか？'),
          const SizedBox(height: 8),
          Text(
            '申請日時 : ${dateText('yyyy/MM/dd HH:mm', widget.groupLogin.createdAt)}',
          ),
          Text('ユーザー名 : ${widget.groupLogin.userName}'),
        ],
      ),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        widget.accept
            ? CustomButton(
                labelText: '承認する',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  groupLoginService.update({
                    'id': widget.groupLogin.id,
                    'accept': true,
                  });
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              )
            : CustomButton(
                labelText: '却下する',
                labelColor: kWhiteColor,
                backgroundColor: kRedColor,
                onPressed: () async {
                  groupLoginService.delete({'id': widget.groupLogin.id});
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
      ],
    );
  }
}
