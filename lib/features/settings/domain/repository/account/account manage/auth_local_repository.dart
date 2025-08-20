
import '../../../../../user/domain/entities/user_entity.dart';

abstract class AuthLocalRepository {
  Future<void> saveNewAccount(UserEntity user);
  Future<UserEntity?> getCurrentAccount();
  Future<List<UserEntity>> getAllAccounts();
  Future<void> switchToAccount(String uid);
  Future<void> deleteAccount(String uid);
}
