import 'package:fluent_ui/fluent_ui.dart';

const kBackColor = Color(0xFFF4F5F7);
const kBaseColor = Color(0xFF3F51B5);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kGrey2Color = Color(0xFF757575);
const kGrey3Color = Color(0xFFCCCCCC);
const kRedColor = Color(0xFFF44336);
const kBlueColor = Color(0xFF2196F3);
const kGreenColor = Color(0xFF4CAF50);
const kOrangeColor = Color(0xFFFF9800);

FluentThemeData customTheme() {
  return FluentThemeData(
    fontFamily: 'SourceHanSansJP-Regular',
    activeColor: kBaseColor,
    cardColor: kWhiteColor,
    scaffoldBackgroundColor: kBackColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    navigationPaneTheme: const NavigationPaneThemeData(
      backgroundColor: kWhiteColor,
      highlightColor: kBaseColor,
    ),
    checkboxTheme: CheckboxThemeData(
      checkedDecoration: ButtonState.all<Decoration>(
        BoxDecoration(
          color: kBaseColor,
          border: Border.all(color: kBaseColor),
        ),
      ),
      uncheckedDecoration: ButtonState.all<Decoration>(
        BoxDecoration(
          color: kBackColor,
          border: Border.all(color: kBaseColor),
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1,
      decoration: BoxDecoration(color: kGreyColor),
      verticalMargin: EdgeInsets.zero,
      horizontalMargin: EdgeInsets.zero,
    ),
  );
}

List<Color> kPlanColors = const [
  Color(0xFF2196F3),
  Color(0xFFF44336),
  Color(0xFF4CAF50),
  Color(0xFFFFC107),
];

DateTime kFirstDate = DateTime.now().subtract(const Duration(days: 1095));
DateTime kLastDate = DateTime.now().add(const Duration(days: 1095));


