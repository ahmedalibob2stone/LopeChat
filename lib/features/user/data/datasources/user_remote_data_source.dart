  import 'dart:io';

  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  import '../../../../storsge/repository.dart';
  import '../../domain/entities/user_entity.dart';
  import '../../model/user_model/user_model.dart';

    class UserRemoteDataSource {
      final FirebaseFirestore fire  ;
      final FirebaseAuth auth;
      final FirebaseStorageRepository firebaseStorageRepository;

      UserRemoteDataSource({
        required this.fire,
        required this.auth,
        required this.firebaseStorageRepository,
      });

      String? get currentUserId => auth.currentUser?.uid;


      Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc() {
      return fire.collection('users').doc(currentUserId).get();
    }



    Future<void> saveUserData(Map<String, dynamic> userMap) {
      return fire.collection('users').doc(currentUserId).set(userMap);
    }

    Future<void> updateUserField(Map<String, dynamic> fields) {
      return fire.collection('users').doc(currentUserId).update(fields);
    }

    Future<String> uploadProfileImage(File file) {
      return firebaseStorageRepository.storeFiletofirstorage('Profile/$currentUserId', file);
    }

    Future<void> updateProfileImageUrl(String uid, String photoUrl) async {
      await fire.collection('users').doc(uid).update({'profile': photoUrl});
    }

    Stream<UserEntity> getUserById(String uid) {
      return fire.collection('users').doc(uid).snapshots().map(
            (snapshot) => UserModel.fromMap(snapshot.data()!),
      );
      }
        Future<UserModel> getUserByIdOnce(String uid) async {
          final snapshot = await fire.collection('users').doc(uid).get();
          if (!snapshot.exists || snapshot.data() == null) {
            throw Exception("User not found");
          }
          return UserModel.fromMap(snapshot.data()!);
        }



























      Future<void> updateUserName(String name) async {
        await fire.collection('users').doc(currentUserId).update({
          'name': name,
        });
      }

      Future<void> updateUserStatus(String status) async {
        await fire.collection('users').doc(currentUserId).update({
          'statu': status,
        });
      }

      Future<void> updateUserProfilePicture(File file) async {
        final imageUrl = await firebaseStorageRepository.storeFiletofirstorage(
          'Profile/$currentUserId',
          file,
        );
        await fire.collection('users').doc(currentUserId).update({
          'profile': imageUrl,
        });
      }

      Stream<DocumentSnapshot<Map<String, dynamic>>> userDocStream(String uid) {
        return fire.collection('users').doc(uid).snapshots();
      }
      Future<String?> getCurrentUserId() async {
        final uid = auth.currentUser?.uid;
        if (uid == null || uid.isEmpty) {
          throw Exception("User is not authenticated");
        }
        return uid;
      }


    }
