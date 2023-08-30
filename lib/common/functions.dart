import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:works_book_group_web/common/date_machine_util.dart';

Future<int?> getPrefsInt(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

Future setPrefsInt(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

Future<String?> getPrefsString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future setPrefsString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<bool?> getPrefsBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

Future setPrefsBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

Future<List<String>?> getPrefsList(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key);
}

Future setPrefsList(String key, List<String> value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(key, value);
}

Future removePrefs(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

Future allRemovePrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

String dateText(String format, DateTime? date) {
  String ret = '';
  if (date != null) {
    ret = DateFormat(format, 'ja').format(date);
  }
  return ret;
}

String rndText(int length) {
  const tmp = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  int tmpLength = tmp.length;
  final rnd = Random();
  final codeUnits = List.generate(
    length,
    (index) {
      final n = rnd.nextInt(tmpLength);
      return tmp.codeUnitAt(n);
    },
  );
  return String.fromCharCodes(codeUnits);
}

Timestamp convertTimestamp(DateTime date, bool end) {
  String dateTime = '${dateText('yyyy-MM-dd', date)} 00:00:00.000';
  if (end == true) {
    dateTime = '${dateText('yyyy-MM-dd', date)} 23:59:59.999';
  }
  return Timestamp.fromMillisecondsSinceEpoch(
    DateTime.parse(dateTime).millisecondsSinceEpoch,
  );
}

String twoDigits(int n) => n.toString().padLeft(2, '0');

String addTime(String left, String right) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  List<String> lefts = left.split(':');
  List<String> rights = right.split(':');
  double hm = (int.parse(lefts.last) + int.parse(rights.last)) / 60;
  int m = (int.parse(lefts.last) + int.parse(rights.last)) % 60;
  int h = (int.parse(lefts.first) + int.parse(rights.first)) + hm.toInt();
  if (h.toString().length == 1) {
    return '${twoDigits(h)}:${twoDigits(m)}';
  } else {
    return '$h:${twoDigits(m)}';
  }
}

String subTime(String left, String right) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  List<String> lefts = left.split(':');
  List<String> rights = right.split(':');
  // 時 → 分
  int leftM = (int.parse(lefts.first) * 60) + int.parse(lefts.last);
  int rightM = (int.parse(rights.first) * 60) + int.parse(rights.last);
  // 分で引き算
  int diffM = leftM - rightM;
  // 分 → 時
  double h = diffM / 60;
  int m = diffM % 60;
  return '${twoDigits(h.toInt())}:${twoDigits(m)}';
}

List<DateTime> generateDays(DateTime month) {
  List<DateTime> ret = [];
  var dateMap = DateMachineUtil.getMonthDate(month, 0);
  DateTime startTime = DateTime.parse('${dateMap['start']}');
  DateTime endTime = DateTime.parse('${dateMap['end']}');
  for (int i = 0; i <= endTime.difference(startTime).inDays; i++) {
    ret.add(startTime.add(Duration(days: i)));
  }
  return ret;
}

DateTime rebuildDate(DateTime? date, DateTime? time) {
  DateTime ret = DateTime.now();
  if (date != null && time != null) {
    String tmpDate = dateText('yyyy-MM-dd', date);
    String tmpTime = '${dateText('HH:mm', time)}:00.000';
    ret = DateTime.parse('$tmpDate $tmpTime');
  }
  return ret;
}

DateTime rebuildTime(BuildContext context, DateTime? date, String? time) {
  DateTime ret = DateTime.now();
  if (date != null && time != null) {
    String tmpDate = dateText('yyyy-MM-dd', date);
    String tmpTime = '${time.padLeft(5, '0')}:00.000';
    ret = DateTime.parse('$tmpDate $tmpTime');
  }
  return ret;
}
