import 'dart:io';

import '../../model/user_model/user_model.dart';
import '../entities/user_entity.dart';

abstract class IUserRepository {
  Stream<UserEntity?> myData();
  /// Get current user data
  Future<UserEntity?> getCurrentUserData();
  /// Get stream of current user


  /// Get stream of another user by ID
  Stream<UserEntity> userData(String userId);

  /// Save user data to Firebase
  Future<void> saveUserDatetoFirebase({

    required String name,
    required File? profile,
    required String statu,
  });
  Stream<UserEntity> getUserById(String uid);



  /// Set user online/offline state
  Future<void> setUserState(String isOnline);

  /// Update user status message
  Future<void> addStatus(String status);

  /// Update user name
  Future<void> updateName(String name);

  /// Update user profile image url
  Future<void> updateProfileImageUrl(String photoUrl);

  /// Upload user profile image to Firebase
  Future<String> uploadProfileImage(File file);














  Future<void> updateUserName(String name) async {}
  Future<void> updateUserStatus(String status) async {}
  Future<void> updateUserProfilePicture(File file) async {}
  Future<UserEntity> getUserByIdOnce(String uid);
  Future<String?> getCurrentUserId();


}
