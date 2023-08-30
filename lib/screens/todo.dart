import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/providers/auth.dart';

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
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
