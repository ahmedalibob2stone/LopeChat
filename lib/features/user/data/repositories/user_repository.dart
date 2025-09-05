import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/interface_user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../user_model/user_model.dart';

class UserRepository implements IUserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepository({required this.remoteDataSource});

  /// ✅ بيانات المستخدم الحالي (مرة واحدة)
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

  /// ✅ Stream لبيانات المستخدم الحالي
  @override
  Stream<UserEntity?> myData() {
    final uid = remoteDataSource.currentUserId;
    if (uid == null || uid.isEmpty) {
      return Stream.value(null);
    }

    return remoteDataSource.userDocStream(uid).map((doc) {
      final data = doc.data();
      if (data == null) return null;
      return UserModel.fromMap(data).toEntity();
    });
  }

  /// ✅ Stream لمستخدم معين بالـ UID
  @override
  Stream<UserEntity> getUserById(String uid) {
    return remoteDataSource.getUserById(uid).map((model) => model.toEntity());
  }

  /// ✅ بيانات مستخدم معين (مرة واحدة)
  @override
  Future<UserEntity> getUserByIdOnce(String uid) async {
    final model = await remoteDataSource.getUserByIdOnce(uid);
    return model.toEntity();
  }

  /// ✅ حفظ بيانات جديدة في Firebase
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

  /// ✅ تحديث صورة البروفايل
  @override
  Future<void> updateUserProfilePicture(File file) {
    return remoteDataSource.updateUserProfilePicture(file);
  }
}
