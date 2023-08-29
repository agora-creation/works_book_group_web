import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/group_login.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/screens/group_login.dart';
import 'package:works_book_group_web/screens/login.dart';
import 'package:works_book_group_web/services/group_login.dart';
import 'package:works_book_group_web/widgets/app_bar_title.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_icon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GroupLoginService groupLoginService = GroupLoginService();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8),
          child: AppBarTitle('${authProvider.group?.name}'),
        ),
        actions: Padding(
          padding: const EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.centerRight,
            child: CustomIconButton(
              iconData: FluentIcons.settings,
              onPressed: () => showDialog(
                context: context,
                builder: (context) => SignOutDialog(
                  authProvider: authProvider,
                ),
              ),
            ),
          ),
        ),
      ),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (index) {
          setState(() => selectedIndex = index);
        },
        displayMode: PaneDisplayMode.top,
        items: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.shopping_cart),
            title: const Text('スケジュール管理'),
            body: Container(),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.bank),
            title: const Text('Todoタスク管理'),
            body: Container(),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.bank),
            title: const Text('勤怠打刻管理'),
            body: Container(),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.bank),
            title: const Text('所属ユーザー管理'),
            body: Container(),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.account_activity),
            title: const Text('所属申請'),
            body: GroupLoginScreen(authProvider: authProvider),
            infoBadge: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: groupLoginService.streamListRequest(
                authProvider.group?.number,
              ),
              builder: (context, snapshot) {
                List<GroupLoginModel> groupLogins = [];
                if (snapshot.hasData) {
                  for (DocumentSnapshot<Map<String, dynamic>> doc
                      in snapshot.data!.docs) {
                    groupLogins.add(GroupLoginModel.fromSnapshot(doc));
                  }
                }
                if (groupLogins.isEmpty) return Container();
                return InfoBadge(
                  source: Text('${groupLogins.length}'),
                  color: kRedColor,
                );
              },
            ),
          ),
          PaneItemSeparator(),
        ],
      ),
    );
  }
}

class SignOutDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const SignOutDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<SignOutDialog> createState() => _SignOutDialogState();
}

class _SignOutDialogState extends State<SignOutDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'システム情報',
        style: TextStyle(fontSize: 18),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('最終更新日: 2023/07/04 15:49'),
          Text('ログインID: '),
        ],
      ),
      actions: [
        CustomButton(
          labelText: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: 'ログアウト',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            await widget.authProvider.signOut();
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              FluentPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
