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
}
