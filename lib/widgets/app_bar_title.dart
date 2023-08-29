import 'package:fluent_ui/fluent_ui.dart';

class AppBarTitle extends StatelessWidget {
  final String label;

  const AppBarTitle(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 14),
    );
  }
}
