import 'dart:io';
import '../entities/user_entity.dart';

/// واجهة (Interface) مسؤولة عن تعريف جميع العمليات المتعلقة بالمستخدم.
/// كل Repository في Data Layer يجب أن يطبق هذه الواجهة.
abstract class IUserRepository {
  /// جلب بيانات المستخدم الحالي مرة واحدة
  Future<UserEntity?> getCurrentUserData();

  /// Stream لمتابعة بيانات المستخدم الحالي
  Stream<UserEntity?> myData();

  /// Stream لمتابعة بيانات مستخدم محدد بالـ UID
  Stream<UserEntity> getUserById(String uid);

  /// جلب بيانات مستخدم محدد مرة واحدة
  Future<UserEntity> getUserByIdOnce(String uid);

  /// حفظ بيانات المستخدم في Firebase
  Future<void> saveUserDatetoFirebase({
    required String name,
    required File? profile,
    required String statu,
  });

  /// تحديث الاسم
  Future<void> updateUserName(String name);

  /// تحديث الحالة
  Future<void> updateUserStatu(String status);

  /// تحديث صورة البروفايل
  Future<void> updateUserProfilePicture(File file);
}
