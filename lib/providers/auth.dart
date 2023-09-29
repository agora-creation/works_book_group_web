import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/models/group.dart';
import 'package:works_book_group_web/services/group.dart';

enum AuthStatus {
  authenticated,
  uninitialized,
  authenticating,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;
  FirebaseAuth? auth;
  User? _authUser;
  User? get authUser => _authUser;
  GroupService groupService = GroupService();
  GroupModel? _group;
  GroupModel? get group => _group;

  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void clearController() {
    numberController.clear();
    passwordController.clear();
  }

  AuthProvider.initialize() : auth = FirebaseAuth.instance {
    auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> signIn() async {
    String? error;
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      await auth?.signInAnonymously().then((value) async {
        _authUser = value.user;
        GroupModel? tmpGroup = await groupService.select(
          numberController.text,
          passwordController.text,
        );
        if (tmpGroup != null) {
          _group = tmpGroup;
          await setPrefsString('groupNumber', tmpGroup.number);
          await setPrefsString('groupPassword', tmpGroup.password);
        } else {
          await auth?.signOut();
          error = 'ログインに失敗しました';
        }
      });
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      error = 'ログインに失敗しました';
    }
    return error;
  }

  Future signOut() async {
    await auth?.signOut();
    _status = AuthStatus.unauthenticated;
    await allRemovePrefs();
    _group = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future _onStateChanged(User? authUser) async {
    if (authUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authUser = authUser;
      String? tmpGroupNumber = await getPrefsString('groupNumber');
      String? tmpGroupPassword = await getPrefsString('groupPassword');
      GroupModel? tmpGroup = await groupService.select(
        tmpGroupNumber,
        tmpGroupPassword,
      );
      if (tmpGroup == null) {
        _status = AuthStatus.unauthenticated;
      } else {
        _group = tmpGroup;
        _status = AuthStatus.authenticated;
      }
    }
    notifyListeners();
  }

  Future reloadGroup() async {
    String? tmpGroupNumber = await getPrefsString('groupNumber');
    String? tmpGroupPassword = await getPrefsString('groupPassword');
    GroupModel? tmpGroup = await groupService.select(
      tmpGroupNumber,
      tmpGroupPassword,
    );
    if (tmpGroup == null) {
    } else {
      _group = tmpGroup;
    }
    notifyListeners();
  }

  Future<String?> updateInfo({
    required String name,
    required String zipCode,
    required String address,
    required String tel,
    required String email,
    required String password,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'name': name,
        'zipCode': zipCode,
        'address': address,
        'tel': tel,
        'email': email,
        'password': password,
      });
      await setPrefsString('groupPassword', password);
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateLegalHour({
    required int legalHour,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'legalHour': legalHour,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateRoundStartedAt({
    required int roundStartedAtType,
    required int roundStartedAtMinute,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'roundStartedAtType': roundStartedAtType,
        'roundStartedAtMinute': roundStartedAtMinute,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateRoundEndedAt({
    required int roundEndedAtType,
    required int roundEndedAtMinute,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'roundEndedAtType': roundEndedAtType,
        'roundEndedAtMinute': roundEndedAtMinute,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateRoundRestStartedAt({
    required int roundRestStartedAtType,
    required int roundRestStartedAtMinute,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'roundRestStartedAtType': roundRestStartedAtType,
        'roundRestStartedAtMinute': roundRestStartedAtMinute,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateRoundRestEndedAt({
    required int roundRestEndedAtType,
    required int roundRestEndedAtMinute,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'roundRestEndedAtType': roundRestEndedAtType,
        'roundRestEndedAtMinute': roundRestEndedAtMinute,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateRoundDiff({
    required int roundDiffType,
    required int roundDiffMinute,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'roundDiffType': roundDiffType,
        'roundDiffMinute': roundDiffMinute,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateFixed({
    required String fixedStartedAt,
    required String fixedEndedAt,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'fixedStartedAt': fixedStartedAt,
        'fixedEndedAt': fixedEndedAt,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateNight({
    required String nightStartedAt,
    required String nightEndedAt,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'nightStartedAt': nightStartedAt,
        'nightEndedAt': nightEndedAt,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateHolidayWeeks({
    required List<String> holidayWeeks,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'holidayWeeks': holidayWeeks,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateHolidays({
    required List<DateTime> holidays,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'holidays': holidays,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateAutoRest({
    required bool autoRest,
  }) async {
    String? error;
    try {
      groupService.update({
        'id': group?.id,
        'autoRest': autoRest,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }
}
