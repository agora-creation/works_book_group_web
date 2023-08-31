import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/todo.dart';

class TodoList extends StatelessWidget {
  final TodoModel todo;

  const TodoList({
    required this.todo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        backgroundColor: todo.finished == true ? kGrey3Color : null,
        child: ListTile(
          title: Text(todo.title),
          subtitle: Text(todo.details),
        ),
      ),
    );
  }
}
