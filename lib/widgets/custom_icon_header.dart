import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/common/style.dart';

class CustomIconHeader extends StatelessWidget {
  final IconData iconData;
  final String label;

  const CustomIconHeader({
    required this.iconData,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGreyColor)),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
