import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../storsge/repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../model/user_model/user_model.dart';
import '../../domain/repositories/interface_user_repository.dart';
import '../datasources/user_remote_data_source.dart';


final userSubRepositoryProvider = Provider<UserRemoteDataSource>((ref) {
  final storageRepo = ref.read(FirebaseStorageRepositoryProvider);
  return UserRemoteDataSource(
    fire: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    firebaseStorageRepository: storageRepo,
  );
});

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final subRepo = ref.read(userSubRepositoryProvider);
  return UserRepository(subRepository: subRepo, firestore: FirebaseFirestore.instance);
});



class UserRepository  implements IUserRepository {
  FirebaseFirestore firestore;
  final UserRemoteDataSource subRepository;

  UserRepository({required this.subRepository,required this.firestore});

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      final doc = await subRepository.getUserDoc();
      final data = doc.data();
      return data != null ? UserModel.fromMap(data) : null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
  Stream<UserEntity?> myData() {
    final uid = subRepository.currentUserId;

    if (uid == null || uid.isEmpty) {
      return Stream.value(null);
    }

    return subRepository.userDocStream(uid)
        .map((doc) {
      final map = doc.data();
      if (map == null) return null;
      final model = UserModel.fromMap(map);
      return model.toEntity();
    })
        .handleError((error) {
      print('Error in myData(): $error');
    });
  }




  @override
  Stream<UserModel> userData(String userId) {

    return subRepository.userDocStream(userId).map(
          (event) => UserModel.fromMap(event.data()!),
    );
  }

  @override
  Stream<UserEntity> getUserById(String uid) {
    return subRepository.getUserById(uid);
  }

  @override
  Future<void> saveUserDatetoFirebase({

    required String name,
    required File? profile,
    required String statu,
  }) async {

      final uid = subRepository.currentUserId!;
      String photoUrl =
          'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic';

      if (profile != null) {
        photoUrl = await subRepository.uploadProfileImage(profile);
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profile: photoUrl,
        isOnline: '',
        phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber!,
        groupId: [],
        statu: statu, blockedUsers: [], lastSeen: '',
      );

      await subRepository.saveUserData(user.toMap());


    }


  @override
  Future<void> setUserState(String isOnline) async {
    await subRepository.updateUserField({'isOnline': isOnline});
  }

  @override
  Future<void> addStatus(String status) async {
    await subRepository.updateUserField({'statu': status});
  }

  @override
  Future<void> updateName(String name) async {
    await subRepository.updateUserField({'name': name});
  }

  @override
  Future<void> updateProfileImageUrl(String photoUrl) async {
    await subRepository.updateUserField({'profile': photoUrl});
  }

  @override
  Future<String> uploadProfileImage(File file) {
    return subRepository.uploadProfileImage(file);
  }


  @override
  Future<UserEntity> getUserByIdOnce(String uid) async{
    return subRepository.getUserByIdOnce(uid);
  }










  @override
  Future<void> updateUserName(String name) async {
    return subRepository.updateUserName(name);
  }
  @override
  Future<void> updateUserStatus(String status) async {
    return subRepository.updateUserStatus(status);
  }
  @override
  Future<void> updateUserProfilePicture(File file) async {
    return subRepository.updateUserProfilePicture(file);
  }
  @override

  Future<String?> getCurrentUserId() {
    return subRepository.getCurrentUserId();
  }






}
