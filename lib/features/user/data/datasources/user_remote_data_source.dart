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

  /// ✅ حفظ بيانات جديدة لليوزر
  Future<void> saveUserData(UserModel user) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");
    await firestore.collection('users').doc(uid).set(user.toMap());
  }

  /// ✅ رفع صورة البروفايل فقط
  Future<String> uploadProfileImage(File file) {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");
    return storageRepository.storeFiletofirstorage('Profile/$uid', file);
  }

  /// ✅ تحديث الاسم
  Future<void> updateUserName(String name) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");
    await firestore.collection('users').doc(uid).update({'name': name});
  }

  /// ✅ تحديث الحالة
  Future<void> updateUserStatus(String status) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");
    await firestore.collection('users').doc(uid).update({'statu': status});
  }

  /// ✅ تحديث صورة البروفايل
  Future<void> updateUserProfilePicture(File file) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");
    final imageUrl = await storageRepository.storeFiletofirstorage(
      'Profile/$uid',
      file,
    );
    await firestore.collection('users').doc(uid).update({'profile': imageUrl});
  }

  /// ✅ Stream لمستند اليوزر (DocumentSnapshot)
  Stream<DocumentSnapshot<Map<String, dynamic>>> userDocStream(String uid) {
    return firestore.collection('users').doc(uid).snapshots();
  }
}
