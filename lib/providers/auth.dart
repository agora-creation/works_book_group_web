import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:works_book_group_web/common/functions.dart';
import 'package:works_book_group_web/models/group.dart';
import 'package:works_book_group_web/models/group_section.dart';
import 'package:works_book_group_web/services/group.dart';
import 'package:works_book_group_web/services/group_section.dart';

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
  GroupSectionService groupSectionService = GroupSectionService();
  GroupModel? _group;
  GroupSectionModel? _groupSection;
  GroupModel? get group => _group;
  GroupSectionModel? get groupSection => _groupSection;

  AuthProvider.initialize() : auth = FirebaseAuth.instance {
    auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> signIn({
    required String code,
    required String password,
  }) async {
    String? error;
    if (code == '') return '会社コードを入力してください';
    if (code.length != 7) return '必ず7桁で入力してください';
    String groupCode = code.substring(0, 3);
    String sectionCode = code.substring(3, 7);
    if (password == '') return 'パスワードを入力してください';
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final result = await auth?.signInAnonymously();
      _authUser = result?.user;
      GroupModel? tmpGroup = await groupService.select(
        groupCode: groupCode,
      );
      if (tmpGroup != null) {
        GroupSectionModel? tmpGroupSection = await groupSectionService.select(
          groupId: tmpGroup.id,
          sectionCode: sectionCode,
        );
        if (tmpGroupSection != null) {
          if (tmpGroupSection.password == password) {
            _group = tmpGroup;
            _groupSection = tmpGroupSection;
            await setPrefsString('groupCode', groupCode);
            await setPrefsString('sectionCode', sectionCode);
            await setPrefsString('password', password);
          } else {
            await auth?.signOut();
            error = 'ログインに失敗しました';
          }
        } else {
          await auth?.signOut();
          error = 'ログインに失敗しました';
        }
      } else {
        await auth?.signOut();
        error = 'ログインに失敗しました';
      }
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
    _groupSection = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future _onStateChanged(User? authUser) async {
    if (authUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authUser = authUser;
      String? tmpGroupCode = await getPrefsString('groupCode');
      String? tmpSectionCode = await getPrefsString('sectionCode');
      String? tmpPassword = await getPrefsString('password');
      GroupModel? tmpGroup = await groupService.select(
        groupCode: tmpGroupCode,
      );
      if (tmpGroup != null) {
        GroupSectionModel? tmpGroupSection = await groupSectionService.select(
          groupId: tmpGroup.id,
          sectionCode: tmpSectionCode,
        );
        if (tmpGroupSection != null) {
          if (tmpGroupSection.password == tmpPassword) {
            _group = tmpGroup;
            _groupSection = tmpGroupSection;
            _status = AuthStatus.authenticated;
          } else {
            _status = AuthStatus.unauthenticated;
          }
        } else {
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    }
    notifyListeners();
  }

  Future reloadGroup() async {
    String? tmpGroupCode = await getPrefsString('groupCode');
    String? tmpSectionCode = await getPrefsString('sectionCode');
    String? tmpPassword = await getPrefsString('password');
    GroupModel? tmpGroup = await groupService.select(
      groupCode: tmpGroupCode,
    );
    if (tmpGroup != null) {
      GroupSectionModel? tmpGroupSection = await groupSectionService.select(
        groupId: tmpGroup.id,
        sectionCode: tmpSectionCode,
      );
      if (tmpGroupSection != null) {
        if (tmpGroupSection.password == tmpPassword) {
          _group = tmpGroup;
          _groupSection = tmpGroupSection;
        }
      }
    }
    notifyListeners();
  }

  // Future<String?> updateInfo({
  //   required String name,
  //   required String zipCode,
  //   required String address,
  //   required String tel,
  //   required String email,
  //   required String password,
  // }) async {
  //   String? error;
  //   try {
  //     groupService.update({
  //       'id': group?.id,
  //       'name': name,
  //       'zipCode': zipCode,
  //       'address': address,
  //       'tel': tel,
  //       'email': email,
  //       'password': password,
  //     });
  //     await setPrefsString('groupPassword', password);
  //   } catch (e) {
  //     error = e.toString();
  //   }
  //   return error;
  // }
}
