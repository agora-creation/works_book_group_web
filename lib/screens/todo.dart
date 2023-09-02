import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/group.dart';
import 'package:works_book_group_web/models/todo.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/services/todo.dart';
import 'package:works_book_group_web/widgets/custom_button.dart';
import 'package:works_book_group_web/widgets/custom_icon_text_button.dart';
import 'package:works_book_group_web/widgets/custom_text_box.dart';
import 'package:works_book_group_web/widgets/todo_list.dart';

class TodoScreen extends StatefulWidget {
  final AuthProvider authProvider;

  const TodoScreen({
    required this.authProvider,
    super.key,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TodoService todoService = TodoService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomIconTextButton(
                iconData: FluentIcons.add,
                iconColor: kWhiteColor,
                labelText: 'Todoを追加',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AddTodoDialog(
                    group: widget.authProvider.group,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: todoService.streamList(
                widget.authProvider.group?.number,
              ),
              builder: (context, snapshot) {
                List<TodoModel> todos = [];
                if (snapshot.hasData) {
                  for (DocumentSnapshot<Map<String, dynamic>> doc
                      in snapshot.data!.docs) {
                    todos.add(TodoModel.fromSnapshot(doc));
                  }
                }
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    TodoModel todo = todos[index];
                    return TodoList(
                      todo: todo,
                      onChanged: (value) {
                        todoService.update({
                          'id': todo.id,
                          'finished': value ?? false,
                        });
                      },
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ModTodoDialog(
                          todo: todo,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddTodoDialog extends StatefulWidget {
  final GroupModel? group;

  const AddTodoDialog({
    required this.group,
    super.key,
  });

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  TodoService todoService = TodoService();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'Todoを追加',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: 'タイトル',
            child: CustomTextBox(
              controller: titleController,
              placeholder: '',
              keyboardType: TextInputType.name,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '詳細',
            child: CustomTextBox(
              controller: detailsController,
              placeholder: '',
              keyboardType: TextInputType.multiline,
              maxLines: null,
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
          labelText: '上記内容で追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            if (titleController.text == '') return;
            String id = todoService.id();
            todoService.create({
              'id': id,
              'groupNumber': widget.group?.number,
              'title': titleController.text,
              'details': detailsController.text,
              'finished': false,
              'createdUser': '管理者',
              'createdAt': DateTime.now(),
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModTodoDialog extends StatefulWidget {
  final TodoModel todo;

  const ModTodoDialog({
    required this.todo,
    super.key,
  });

  @override
  State<ModTodoDialog> createState() => _ModTodoDialogState();
}

class _ModTodoDialogState extends State<ModTodoDialog> {
  TodoService todoService = TodoService();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo.title;
    detailsController.text = widget.todo.details;
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'Todoを編集',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: 'タイトル',
            child: CustomTextBox(
              controller: titleController,
              placeholder: '',
              keyboardType: TextInputType.name,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '詳細',
            child: CustomTextBox(
              controller: detailsController,
              placeholder: '',
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '作成日時: ${dateText('yyyy/MM/dd HH:mm', widget.todo.createdAt)}',
            style: const TextStyle(
              color: kGreyColor,
              fontSize: 14,
            ),
          ),
          Text(
            '作成者: ${widget.todo.createdUser}',
            style: const TextStyle(
              color: kGreyColor,
              fontSize: 14,
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
          labelText: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            todoService.delete({'id': widget.todo.id});
            Navigator.pop(context);
          },
        ),
        CustomButton(
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            if (titleController.text == '') return;
            todoService.update({
              'id': widget.todo.id,
              'title': titleController.text,
              'details': detailsController.text,
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
