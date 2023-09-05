import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/group_login.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/screens/group_login.dart';
import 'package:works_book_group_web/screens/login.dart';
import 'package:works_book_group_web/screens/record.dart';
import 'package:works_book_group_web/screens/schedule.dart';
import 'package:works_book_group_web/screens/todo.dart';
import 'package:works_book_group_web/screens/user.dart';
import 'package:works_book_group_web/services/group.dart';
import 'package:works_book_group_web/services/group_login.dart';
import 'package:works_book_group_web/widgets/app_bar_title.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_icon_button.dart';
import 'package:works_book_group_web/widgets/custom_text_box.dart';

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
            body: ScheduleScreen(authProvider: authProvider),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.bank),
            title: const Text('Todoタスク管理'),
            body: TodoScreen(authProvider: authProvider),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.bank),
            title: const Text('勤怠打刻管理'),
            body: RecordScreen(authProvider: authProvider),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.bank),
            title: const Text('所属ユーザー管理'),
            body: UserScreen(authProvider: authProvider),
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
  GroupService groupService = GroupService();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    zipCodeController.text = widget.authProvider.group?.zipCode ?? '';
    addressController.text = widget.authProvider.group?.address ?? '';
    telController.text = widget.authProvider.group?.tel ?? '';
    emailController.text = widget.authProvider.group?.email ?? '';
    passwordController.text = widget.authProvider.group?.password ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '会社・組織情報',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '会社・組織番号',
            child: Text('${widget.authProvider.group?.number}'),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '会社・組織名',
            child: Text('${widget.authProvider.group?.name}'),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '郵便番号',
            child: CustomTextBox(
              controller: zipCodeController,
              placeholder: '',
              keyboardType: TextInputType.number,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '住所',
            child: CustomTextBox(
              controller: addressController,
              placeholder: '',
              keyboardType: TextInputType.streetAddress,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '電話番号',
            child: CustomTextBox(
              controller: telController,
              placeholder: '',
              keyboardType: TextInputType.phone,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: 'メールアドレス',
            child: CustomTextBox(
              controller: emailController,
              placeholder: '',
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: 'パスワード',
            child: CustomTextBox(
              controller: passwordController,
              placeholder: '',
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              maxLines: 1,
            ),
          ),
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
        CustomButton(
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            groupService.update({
              'id': widget.authProvider.group?.id,
              'zipCode': zipCodeController.text,
              'address': addressController.text,
              'tel': telController.text,
              'email': emailController.text,
              'password': passwordController.text,
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
