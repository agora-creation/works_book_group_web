import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/models/todo.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/services/todo.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 750,
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
                      return ListTile(
                        title: Text(todo.content),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
