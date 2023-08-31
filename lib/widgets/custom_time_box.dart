import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/common/style.dart';

class CustomTimeBox extends StatelessWidget {
  final DateTime? value;
  final Function()? onTap;

  const CustomTimeBox({
    this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String text = '';
    if (value != null) {
      text = dateText('HH:mm', value);
    }
    return TextBox(
      controller: TextEditingController(text: text),
      placeholder: '時:分',
      suffix: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(
          FluentIcons.time_picker,
          color: kGreyColor,
        ),
      ),
      readOnly: true,
      onTap: onTap,
    );
  }
}
