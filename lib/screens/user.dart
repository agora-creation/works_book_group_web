import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:works_book_group_web/models/user.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/screens/user_source.dart';
import 'package:works_book_group_web/services/user.dart';
import 'package:works_book_group_web/widgets/custom_cell.dart';
import 'package:works_book_group_web/widgets/custom_data_grid.dart';

class UserScreen extends StatefulWidget {
  final AuthProvider authProvider;

  const UserScreen({
    required this.authProvider,
    super.key,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserService userService = UserService();
  List<UserModel> users = [];

  void _getUsers() async {
    List<UserModel> tmpUsers = await userService.selectList(
      widget.authProvider.group?.number,
    );
    if (mounted) {
      setState(() => users = tmpUsers);
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.authProvider.group?.name}に所属中のユーザーデータを一覧で表示します。',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 600,
                  child: CustomDataGrid(
                    source: UserSource(users: users),
                    columns: [
                      GridColumn(
                        columnName: 'name',
                        label: const CustomCell(label: 'ユーザー名'),
                      ),
                      GridColumn(
                        columnName: 'email',
                        label: const CustomCell(label: 'メールアドレス'),
                      ),
                    ],
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
