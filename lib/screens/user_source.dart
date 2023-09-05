import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/user.dart';
import 'package:works_book_group_web/services/group_login.dart';
import 'package:works_book_group_web/services/user.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_cell.dart';

class UserSource extends DataGridSource {
  final BuildContext context;
  final List<UserModel> users;
  final Function() getUsers;

  UserSource({
    required this.context,
    required this.users,
    required this.getUsers,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = users.map<DataGridRow>((user) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: user.id,
        ),
        DataGridCell(
          columnName: 'number',
          value: user.number,
        ),
        DataGridCell(
          columnName: 'name',
          value: user.name,
        ),
        DataGridCell(
          columnName: 'email',
          value: user.email,
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
    UserModel user = users.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    cells.add(CustomCell(label: '${row.getCells()[1].value}'));
    cells.add(CustomCell(label: '${row.getCells()[2].value}'));
    cells.add(CustomCell(label: '${row.getCells()[3].value}'));
    cells.add(Row(
      children: [
        CustomButton(
          labelText: '編集',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        CustomButton(
          labelText: '脱退させる',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ClearGroupDialog(
              getUsers: getUsers,
              user: user,
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

class ClearGroupDialog extends StatefulWidget {
  final UserModel user;
  final Function() getUsers;

  const ClearGroupDialog({
    required this.user,
    required this.getUsers,
    super.key,
  });

  @override
  State<ClearGroupDialog> createState() => _ClearGroupDialogState();
}

class _ClearGroupDialogState extends State<ClearGroupDialog> {
  GroupLoginService groupLoginService = GroupLoginService();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '脱退させる',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('以下のユーザーをアゴラクリエーションから脱退させますか？'),
          const SizedBox(height: 8),
          Text('ユーザー名 : ${widget.user.name}'),
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
          labelText: '脱退させる',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            userService.update({
              'id': widget.user.id,
              'groupNumber': '',
            });
            groupLoginService.delete({'id': widget.user.id});
            widget.getUsers();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
