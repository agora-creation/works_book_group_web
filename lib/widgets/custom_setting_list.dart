import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/common/style.dart';

class CustomSettingList extends StatelessWidget {
  final String label;
  final String value;
  final Function()? onTap;

  const CustomSettingList({
    required this.label,
    required this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kGreyColor)),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  value,
                  style: const TextStyle(color: kGreyColor),
                ),
              ],
            ),
            const Icon(FluentIcons.edit),
          ],
        ),
      ),
    );
  }
}
