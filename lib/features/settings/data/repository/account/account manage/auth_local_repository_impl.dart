import 'dart:async';

import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../../user/data/user_model/user_model.dart';
import '../../../../domain/repository/account/account manage/auth_local_repository.dart';
import '../../../datasource/account/account manage/local_auth_data_source.dart dart.dart';


class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final LocalAuthDataSource _localDataSource;

  AuthLocalRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveNewAccount(UserEntity user)async {
    final model = UserModel.fromEntity(user); // التحويل يتم هنا فقط
    await _localDataSource.saveNewAccount(model);
  }

  @override
  Future<UserEntity?> getCurrentAccount() {
    return _localDataSource.getCurrentAccount();
  }

  @override
  Future<List<UserEntity>> getAllAccounts() {
    return _localDataSource.getAllAccounts();
  }

  @override
  Future<void> switchToAccount(String uid) {
    return _localDataSource.switchToAccount(uid);
  }

  @override
  Future<void> deleteAccount(String uid) {
    return _localDataSource.deleteAccount(uid);
  }
}
