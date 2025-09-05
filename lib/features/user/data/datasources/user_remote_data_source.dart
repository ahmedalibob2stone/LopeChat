import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../storsge/repository.dart'; // فقط مسؤول عن تخزين الصور
import '../user_model/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorageRepository storageRepository;

  UserRemoteDataSource({
    required this.firestore,
    required this.auth,
    required this.storageRepository,
  });

  /// ✅ إرجاع UID الحالي
  String? get currentUserId => auth.currentUser?.uid;

  /// ✅ إرجاع DocumentSnapshot لليوزر الحالي (مرة واحدة)
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc() async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");
    return firestore.collection('users').doc(uid).get();
  }

  /// ✅ Stream ليوزر محدد
  Stream<UserModel> getUserById(String uid) {
    return firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        throw Exception("User not found");
      }
      return UserModel.fromMap(data);
    });
  }

  /// ✅ إرجاع يوزر مرة واحدة
  Future<UserModel> getUserByIdOnce(String uid) async {
    final snapshot = await firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      throw Exception("User not found");
    }
    return UserModel.fromMap(data);
  }

  Future<void> saveUserData(UserModel user) async {
    final uid = currentUserId;
    await firestore.collection('users').doc(uid).set(user.toMap());
  }

  Future<String> uploadProfileImage(File file) {
    final uid = currentUserId;
    return storageRepository.storeFiletofirstorage('Profile/$uid', file);
  }

  Future<void> updateUserName(String name) async {
    final uid = currentUserId;
    await firestore.collection('users').doc(uid).set({'name': name}, SetOptions(merge: true));

  }

  /// ✅ تحديث الحالة
  Future<void> updateUserStatus(String status) async {
    final uid = currentUserId;
    await firestore.collection('users').doc(uid).set(
      { 'statu': status,},SetOptions(merge: true)
    );
  }

  Future<void> updateUserProfilePicture(File file) async {
    final uid = currentUserId;
    final imageUrl = await storageRepository.storeFiletofirstorage(
      'users/$uid/Profile/$uid',
      file,
    );
    await firestore.collection('users').doc(uid).set(
        ({'profile': imageUrl}),SetOptions(merge: true)
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userDocStream(String uid) {
    return firestore.collection('users').doc(uid).snapshots();
  }
  Future<void> saveUserDatetoFirebase({
    required String name,
    required File? profile,
    required String statu,
  }) async {
    try {

      final uid = currentUserId ?? "";
      final phone = auth.currentUser?.phoneNumber ?? "";
      String photoUrl =
          "https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic";

      if (profile != null) {
        photoUrl = await storageRepository.storeFiletofirstorage('Profile/$uid', profile);
      }
      final user = UserModel(
        name: name.isEmpty ? "" : name,
        uid: uid,
        profile: photoUrl,
        isOnline: "false",
        lastSeen: "",
        phoneNumber: phone,
        groupId: [],
        statu: statu.isEmpty ? "" : statu,
        blockedUsers: [],
      );

      // حفظ المستند الأولي لجميع الحقول
      await firestore.collection('users').doc(uid).set(user.toMap(),SetOptions(merge: true));
    } catch (e, st) {
      print("Error saving user data: $e");
      print("StackTrace: $st");
      rethrow;
    }
  }

}
