import '../repositories/status_repository.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../repositories/status_repository.dart';
import 'dart:io';
import '../repositories/status_repository.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class UploadStatusUseCase {
  final IStatusRepository repository;

  UploadStatusUseCase(this.repository);

  Future<void> call({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required String statusMessage,
    required Map<String, List<String>> seenBy,


  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }
    final uid=currentUser
        !.uid;

    // استدعاء الـ repository
    await repository.uploadStatus(
      username: username,
      profilePic: profilePic,
      phoneNumber: phoneNumber,
      statusImage: statusImage,
      statusMessage: statusMessage,
      seenBy: {}, uid: uid,
    );
  }
}
