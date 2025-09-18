import 'dart:io';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/interface_user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../user_model/user_model.dart';

class UserRepository implements IUserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepository({required this.remoteDataSource});

  @override
  Future<UserEntity?> getCurrentUserData() async {
    try {
      final doc = await remoteDataSource.getUserDoc();
      final data = doc.data();
      if (data == null) return null;
      return UserModel.fromMap(data).toEntity();
    } catch (e) {
      print("Error in getCurrentUserData: $e");
      return null;
    }
  }

  @override
  Stream<UserEntity?> myData() {
    return remoteDataSource.currentUserStream().map((userModel) {
      if (userModel == null) return null;
      return userModel.toEntity();
    });
  }


  @override
  Stream<UserEntity> getUserById(String uid) {
    return remoteDataSource.getUserById(uid).map((model) => model.toEntity());
  }

  @override
  Future<UserEntity> getUserByIdOnce() async {
    final model = await remoteDataSource.getUserByIdOnce();
    return model.toEntity();
  }

  @override
  Future<void> saveUserDatetoFirebase({
    required String name,
    required File? profile,
    required String statu,
  }) async {
    return remoteDataSource.saveUserDatetoFirebase(name: name, profile: profile, statu: statu);
  }

  /// ✅ تحديث الاسم
  @override
  Future<void> updateUserName(String name) {
    return remoteDataSource.updateUserName(name);
  }

  /// ✅ تحديث الحالة
  @override
  Future<void> updateUserStatu(String status) {
    return remoteDataSource.updateUserStatus(status);
  }

  @override
  Future<void> updateUserProfilePicture(File file) {
    return remoteDataSource.updateUserProfilePicture(file);
  }
}
