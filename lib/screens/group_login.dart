import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:works_book_group_web/models/group_login.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/screens/group_login_source.dart';
import 'package:works_book_group_web/services/group_login.dart';
import 'package:works_book_group_web/widgets/custom_cell.dart';
import 'package:works_book_group_web/widgets/custom_data_grid.dart';

class GroupLoginScreen extends StatefulWidget {
  final AuthProvider authProvider;

  const GroupLoginScreen({
    required this.authProvider,
    super.key,
  });

  @override
  State<GroupLoginScreen> createState() => _GroupLoginScreenState();
}

class _GroupLoginScreenState extends State<GroupLoginScreen> {
  GroupLoginService groupLoginService = GroupLoginService();

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
                const Text(
                  'ユーザーが会社・組織への所属申請があった場合に、二段階認証の為、ここに所属申請が送られます。\n『承認』するまでは、ユーザーは利用できません。身に覚えのない申請は『却下』してください。',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 600,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: groupLoginService.streamListRequest(
                      widget.authProvider.group?.number,
                    ),
                    builder: (context, snapshot) {
                      List<GroupLoginModel> groupLogins = [];
                      if (snapshot.hasData) {
                        for (DocumentSnapshot<Map<String, dynamic>> doc
                            in snapshot.data!.docs) {
                          groupLogins.add(GroupLoginModel.fromSnapshot(doc));
                        }
                      }
                      return CustomDataGrid(
                        source: GroupLoginSource(
                          context: context,
                          groupLogins: groupLogins,
                        ),
                        columns: [
                          GridColumn(
                            columnName: 'createdAt',
                            label: const CustomCell(label: '申請日時'),
                          ),
                          GridColumn(
                            columnName: 'userName',
                            label: const CustomCell(label: 'ユーザー名'),
                          ),
                          GridColumn(
                            columnName: 'accept_reject',
                            label: const CustomCell(label: '操作'),
                          ),
                        ],
                      );
                    },
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
