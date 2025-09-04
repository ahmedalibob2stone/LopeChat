import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lopechat/features/user/data/user_model/user_model.dart';

class LocalAuthDataSource {
  static const _currentUserIdKey = 'currentUserId';
  static const _allAccountsKey = 'allAccounts';

  Future<void> saveNewAccount(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, userModel.uid);
    final List<String> allAccounts = prefs.getStringList(_allAccountsKey) ?? [];
    if (!allAccounts.contains(userModel.uid)) {
      allAccounts.add(userModel.uid);
      await prefs.setStringList(_allAccountsKey, allAccounts);
    }
    await prefs.setString('user_${userModel.uid}', jsonEncode(userModel.toMap()));
  }

  Future<UserModel?> getCurrentAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(_currentUserIdKey);
    if (uid == null) return null;
    final jsonString = prefs.getString('user_$uid');
    if (jsonString == null) return null;
    return UserModel.fromMap(jsonDecode(jsonString));
  }

  Future<List<UserModel>> getAllAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final uids = prefs.getStringList(_allAccountsKey) ?? [];
    List<UserModel> users = [];
    for (var uid in uids) {
      final jsonString = prefs.getString('user_$uid');
      if (jsonString != null) {
        users.add(UserModel.fromMap(jsonDecode(jsonString)));
      }
    }
    return users;
  }

  Future<void> switchToAccount(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, uid);
  }

  Future<void> deleteAccount(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final allAccounts = prefs.getStringList(_allAccountsKey) ?? [];
    allAccounts.remove(uid);
    await prefs.setStringList(_allAccountsKey, allAccounts);
    await prefs.remove('user_$uid');
    final currentUid = prefs.getString(_currentUserIdKey);
    if (currentUid == uid) {
      await prefs.remove(_currentUserIdKey);
    }
  }
}