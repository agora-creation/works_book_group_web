import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/models/todo.dart';

class TodoList extends StatelessWidget {
  final TodoModel todo;
  final Function(bool?)? onChanged;
  final Function()? onPressed;

  const TodoList({
    required this.todo,
    this.onChanged,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        backgroundColor: todo.finished == true ? kGrey3Color : null,
        child: Row(
          children: [
            Checkbox(
              checked: todo.finished,
              onChanged: onChanged,
            ),
            Expanded(
              child: ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.details),
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
